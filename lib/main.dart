import 'package:flutter/material.dart';

import 'package:flutter_demo/ui/pages/workouts_page.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:flutter_demo/ui/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/ui/pages/home_page.dart';
import 'package:flutter_demo/ui/pages/favorites.dart';
import 'package:flutter_demo/ui/pages/exercises_page.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<DBManager> loadDataBase() async {
    final dbManager = DBManager.loadDatabase();
    return dbManager;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DBManager>(
        future: loadDataBase(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final DBManager dbManager = snapshot.data!;

            return ChangeNotifierProvider<DBManager>(
              create: (context) => dbManager,
              child: MaterialApp(
                title: 'WytwarzaniaBrakApp',
                theme: ThemeData(
                  primarySwatch: Colors.indigo,
                ),
                routes: {
                  HomePage.routeName: (context) => HomePage(title: 'WytwarzaniaBrak'),
                  FavoritesPage.routeName: (context) => const FavoritesPage(),
                  ExercisesPage.routeName: (context) => const ExercisesPage(),
                  MapPage.routeName: (context) => const MapPage(),
                  WorkoutsPage.routeName: (context) => const WorkoutsPage()
                },
                initialRoute: HomePage.routeName,
              ),
            );
          }
        });
  }
}
