import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'joke.dart';

const chuckURL = "https://api.chucknorris.io/jokes/random";
const buttonHeight = 65.0;
const buttonWidth = 150.0;

var fire = 0;
var crap = 0;

final dio = Dio();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  final PageController _jokePageController = PageController();

  @override
  void dispose() {
    _jokePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(2, 5, 1, 5),
                  child: Text(
                    "💩: $crap",
                    style: const TextStyle(fontSize: 30),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(1, 5, 2, 5),
                  child: SizedBox(
                      child: Text(
                    "🔥: $fire",
                    style: const TextStyle(fontSize: 30),
                  )))
            ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: PageView.builder(
                    controller: _jokePageController,
                    physics: const NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: true,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder<Joke>(
                          future: getRandomJoke(),
                          builder: (context, AsyncSnapshot<Joke> snapshot) {
                            if (snapshot.hasData) {
                              String? jokeText = "";
                              String? jokeIconUrl = "";

                              jokeText = snapshot.data?.value;
                              jokeIconUrl = snapshot.data?.iconUrl;

                              return createJokePage(jokeText, jokeIconUrl);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          });
                    },
                    onPageChanged: (page) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 1, 5),
                  child: SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                        onPressed: () {
                          nextPage(_jokePageController);
                          crap++;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            textStyle: const TextStyle(fontSize: 30)),
                        child: const Text(
                          "💩",
                          textScaleFactor: 1.4,
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(1, 2, 2, 5),
                  child: SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                        onPressed: () {
                          nextPage(_jokePageController);
                          fire++;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            textStyle: const TextStyle(fontSize: 30)),
                        child: const Text("🔥", textScaleFactor: 1.4)),
                  ))
            ])
          ],
        ),
      ),
    );
  }
}

Future<Joke> getRandomJoke() async {
  final response = await dio.get(chuckURL);

  Joke joke = Joke.fromJson(response.data);
  return joke;
}

createJokePage(String? text, String? iconUrl) {
  return Container(
      color: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/chuck-placeholder.png'),
              ),
              Text(
                text!,
                textScaleFactor: 1.2,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ));
}

void nextPage(var pageController) {
  pageController.nextPage(
      duration: const Duration(milliseconds: 200), curve: Curves.easeInOutSine);
}
