import 'package:flutter/material.dart';
import 'package:joke_inder/screens/ScreenProvider.dart';
import 'package:provider/provider.dart';

class ChuckDrawer extends StatelessWidget {
  const ChuckDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              margin:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Colors.blue[200],
              ),
              child: const Center(
                child: Text(
                  'ChuckInder',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('ChuckInder'),
            onTap: () {
              Provider.of<ScreenProvider>(context, listen: false)
                  .changeCurrentScreen(Screen.home);
            },
          ),
          ListTile(
            title: const Text('Favorite Chucks'),
            onTap: () {
              Provider.of<ScreenProvider>(context, listen: false)
                  .changeCurrentScreen(Screen.favorites);
            },
          ),
        ],
      ),
    );
  }
}