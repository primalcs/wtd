import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            title: const Text('Reel Settings'),
            onTap: () {
              Navigator.popAndPushNamed(context, "/reelconfig");
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.popAndPushNamed(context, "/settings");
            },
          ),
        ],
      ),
    );
  }
}
