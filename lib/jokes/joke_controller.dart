import 'package:joke_inder/jokes/joke.dart';

import 'package:dio/dio.dart';
import 'package:joke_inder/main.dart';

enum JokeFeedback {
  NiceJoke,
  BadJoke
}

class JokeController {

  final Dio _dio = Dio();
  final _chuckURL = "https://api.chucknorris.io/jokes/random";
  final _jokeCache = 5;
  var _initialized = false;

  var _goodCount = 0;
  var _badCount = 0;

  List<Joke> jokes = [];

  JokeController._() {}

  static final JokeController instance = JokeController._();

  static JokeController create() {
    return instance;
  }

  int get goodCount => _goodCount;
  int get badCount => _badCount;

  Future<List<Joke>> initializeJokesList() async {

    if (!_initialized) {
      for (var i = 0; i < _jokeCache; i++) {
        print("initializing joke cache ($i)");
        Joke joke = await getJoke();
        jokes.add(joke);
      }

      _initialized = true;
    }

    return jokes;
  }

  bool waitUntilLoaded() {
    while (!_initialized) {}
    return true;
  }

  void sendJokeFeedback(int index, JokeFeedback feedback) {
    if (feedback == JokeFeedback.NiceJoke) {
      _goodCount++;
    } else {
      _badCount++;
    }
  }

  void updateJoke(int index) async {
    Joke newJoke = await getJoke();

    jokes[index] = newJoke;
  }

  Future<Joke> getJoke() async {
    print("before response");
    final response = await _dio.get(_chuckURL);
    print("after response");

    Joke joke = Joke.fromJson(response.data);
    return joke;
  }
}