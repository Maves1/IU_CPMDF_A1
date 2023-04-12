import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:joke_inder/screens/drawer.dart';
import 'package:provider/provider.dart';

import '../jokes/joke.dart';
import '../jokes/joke_model.dart';
import '../main.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  final String title = "Favorites";

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();

}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const ChuckDrawer(),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: AppinioSwiper(
                              cardsCount: model.favoriteCount == 0 ? 1 : model.favoriteCount,
                              loop: true,
                              swipeOptions: AppinioSwipeOptions.horizontal,
                              onSwipe: (int index, var swipeDirection) {
                                // log("${(index - 1) % model.favoriteCount} $swipeDirection");
                              },
                              cardsBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: model.favoriteCount != 0
                                      ? createJokePage(
                                      model.favorites[index])
                                      : createNoFavoritesPlaceholder()
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
              });
        }),
      ),
    );
  }

  createNoFavoritesPlaceholder() {
    String? text = "Hey, buddy, you've got not favorites! Don't disappoint me!";

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
}