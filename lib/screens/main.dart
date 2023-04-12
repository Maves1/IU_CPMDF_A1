import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joke_inder/screens/ScreenProvider.dart';
import 'package:joke_inder/screens/drawer.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: context.watch<ScreenProvider>().currentScreen,
      ),
    );
  }
}