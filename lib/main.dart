import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:joke_inder/jokes/joke_controller.dart';
import 'package:joke_inder/jokes/joke_model.dart';
import 'package:provider/provider.dart';

import 'dart:developer';
import 'jokes/joke.dart';

const buttonHeight = 65.0;
const buttonWidth = 150.0;
const jokeCacheSize = 5;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ref) => JokeModel(jokeCacheSize),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChuckInder',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(title: 'ChuckInder'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppinioSwiperController swipeController = AppinioSwiperController();

  @override
  void dispose() {
    swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Consumer<JokeModel>(builder: (context, model, child) {
          return FutureBuilder<List<Joke>>(
              future: model.init(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Joke>> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(2, 5, 1, 5),
                                child: Text(
                                  getJokesCountString(false, model),
                                  style: const TextStyle(fontSize: 30),
                                )),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(1, 5, 2, 5),
                                child: SizedBox(
                                    child: Text(
                                  getJokesCountString(true, model),
                                  style: const TextStyle(fontSize: 30),
                                )))
                          ]),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: AppinioSwiper(
                              controller: swipeController,
                              cardsCount: jokeCacheSize,
                              loop: true,
                              swipeOptions: AppinioSwipeOptions.allDirections,
                              onSwipe: (int index, var swipeDirection) {
                                log("${(index - 1) % jokeCacheSize} $swipeDirection");

                                var feedback = swipeDirection ==
                                    AppinioSwiperDirection.right
                                    ? JokeFeedback.NiceJoke
                                    : JokeFeedback.BadJoke;

                                model.sendJokeFeedback(
                                    (index - 1) % jokeCacheSize, feedback);
                                model
                                    .updateJoke((index - 1) % jokeCacheSize);
                              },
                              cardsBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: createJokePage(
                                      model.jokes[index]),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // MaterialButton(onPressed: onPressed)
                        ],
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        }),
      ),
    );
  }
}

createJokePage(Joke joke) {
  String? text = joke.value;
  String? iconUrl = joke.iconUrl;

  return Container(
      color: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/chuck-placeholder.png'),
            ),
            Text(
              text,
              textScaleFactor: 1.2,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ));
}

String getJokesCountString(bool isGood, JokeModel jokeModel) {
  final emoji = isGood ? "🔥" : "💩";
  final count = isGood ? jokeModel.favoriteCount : jokeModel.badCount;
  return "$emoji: $count";
}
