import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/workouts_page.dart';
import 'package:flutter_demo/ui/pages/exercises_page.dart';
import 'package:flutter_demo/ui/pages/map_page.dart';
import 'package:provider/provider.dart';
import '../storage/dbmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('WytwarzaniaBrak'),
            accountEmail: Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    'https://media.istockphoto.com/photos/fire-sparks-background-picture-id1151621424?k=20&m=1151621424&s=612x612&w=0&h=5ngdyZBKbTaBgc95SKhyJ55caca-GBQck-_tC7yKWtw=',
                  )),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () => Navigator.pushNamed(context, MapPage.routeName, arguments: MapMode.NONE),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Exercises'),
            onTap: () => Navigator.pushNamed(context, ExercisesPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Workouts'),
            onTap: () => Navigator.pushNamed(context, WorkoutsPage.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.scanner),
            title: Text('Scan area'),
            onTap: () => Navigator.pushNamed(context, MapPage.routeName, arguments: MapMode.SCAN),
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Reload data'),
            onTap: () async {
              _showLoaderDialog(context);
              int result = await dbManager.updateAllData();
              Navigator.pop(context);

              Fluttertoast.showToast(
                msg: result == 200
                    ? "Reloaded data successfully"
                    : "Couldn't load server data; Error code: $result",
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }

  _showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
