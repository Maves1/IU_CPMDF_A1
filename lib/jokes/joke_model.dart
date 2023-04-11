import 'package:flutter/foundation.dart';
import 'package:joke_inder/jokes/joke_controller.dart';

import 'joke.dart';

class JokeModel extends ChangeNotifier {

  bool _initialized = false;
  int _modelSize = 5;
  int _badCount;

  List<Joke> _model = [];
  List<Joke> _favorites = [];

  JokeController jokeController;

  JokeModel(this._modelSize) :
           _badCount = 0, jokeController = JokeController.instance(_modelSize);

  Future<List<Joke>> init() async {
    if (!_initialized) {
      _model = await jokeController.initializeJokesList(this);
      _initialized = true;
    }

    return _model;
  }
  
  List<Joke> get jokes => _model;
  int get favoriteCount => _favorites.length;
  int get badCount => _badCount;
  
  void setJoke(int index, Joke joke) {
    if (index >= 0 && index < _model.length) {
      _model[index] = joke;
    }
  }

  void sendJokeFeedback(int index, JokeFeedback feedback) {
    if (feedback == JokeFeedback.NiceJoke) {
      _favorites.add(_model[index]);
    } else {
      _badCount++;
    }

    notifyListeners();
  }

  void updateJoke(int index) async {
    Joke newJoke = await jokeController.getJoke();

    setJoke(index, newJoke);
  }
}