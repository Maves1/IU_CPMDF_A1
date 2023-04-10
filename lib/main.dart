import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:joke_inder/jokes/joke_controller.dart';

import 'dart:developer';
import 'jokes/joke.dart';

JokeController jokeController = JokeController.create();

const buttonHeight = 65.0;
const buttonWidth = 150.0;
const jokeCacheSize = 5;

void main() async {
  runApp(const MyApp());
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
  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Joke>>(
            future: jokeController.initializeJokesList(),
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
                                getJokesCountString(false),
                                style: const TextStyle(fontSize: 30),
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(1, 5, 2, 5),
                              child: SizedBox(
                                  child: Text(
                                    getJokesCountString(true),
                                    style: const TextStyle(fontSize: 30),
                                  )))
                        ]),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.75,
                          child: AppinioSwiper(
                            controller: controller,
                            cardsCount: jokeCacheSize,
                            loop: true,
                            swipeOptions: AppinioSwipeOptions.allDirections,
                            allowUnswipe: true,
                            onSwipe: (int index, var swipeDirection) {
                              if (swipeDirection == AppinioSwiperDirection.bottom) {
                                controller.unswipe();
                              } else {
                                log("${(index - 1) %
                                    jokeCacheSize} $swipeDirection");

                                var feedback =
                                swipeDirection == AppinioSwiperDirection.right
                                    ? JokeFeedback.NiceJoke
                                    : JokeFeedback.BadJoke;

                                jokeController.sendJokeFeedback(
                                    (index - 1) % jokeCacheSize,
                                    feedback);
                                jokeController.updateJoke(
                                    (index - 1) % jokeCacheSize);
                                setState(() {

                                });
                              }
                            },
                            cardsBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: createJokePage(
                                    jokeController.jokes[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
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

String getJokesCountString(bool isGood) {
  final emoji = isGood ? "🔥" : "💩";
  final count = isGood ? jokeController.goodCount : jokeController.badCount;
  return "$emoji: $count";
}