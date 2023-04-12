import 'package:flutter/cupertino.dart';
import 'package:joke_inder/screens/favorites.dart';

import '../main.dart';

enum Screen {
  home,
  favorites
}

class ScreenProvider extends ChangeNotifier {

  Widget _currentScreen = const HomePage();

  Widget get currentScreen => _currentScreen;
  set currentScreen(Widget newScreen) {
    _currentScreen = newScreen;
    notifyListeners();
  }

  void changeCurrentScreen(Screen screen){
    switch(screen){
      case Screen.home:
        currentScreen = const HomePage();
        break;
      case Screen.favorites:
        currentScreen = const FavoritesPage();
        break;
    }
  }
}