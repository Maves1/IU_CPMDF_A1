import 'package:flutter/foundation.dart';
import 'package:joke_inder/jokes/joke.dart';

import 'package:dio/dio.dart';
import 'package:joke_inder/jokes/joke_model.dart';
import 'package:joke_inder/main.dart';

enum JokeFeedback {
  NiceJoke,
  BadJoke
}

class JokeController extends ChangeNotifier {

  final Dio _dio = Dio();
  final _chuckURL = "https://api.chucknorris.io/jokes/random";
  int _jokeCache = 5;
  bool _initialized = false;

  int _goodCount = 0;
  int _badCount = 0;

  List<Joke> jokes = [];
  List<Joke> favoriteJokes = [];

  JokeController._() {}

  static final JokeController _instance = JokeController._();

  static JokeController instance(int modelSize) {
    _instance._jokeCache = modelSize;
    return _instance;
  }

  int get goodCount => _goodCount;
  int get badCount => _badCount;

  Future<List<Joke>> initializeJokesList(JokeModel model) async {

    List<Joke> jokes = [];

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

  Future<Joke> getJoke() async {
    print("before response");
    final response = await _dio.get(_chuckURL);
    print("after response");

    Joke joke = Joke.fromJson(response.data);
    return joke;
  }
}