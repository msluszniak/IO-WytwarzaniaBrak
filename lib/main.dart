import 'package:flutter/material.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:flutter_demo/storage/storage.dart';
import 'package:flutter_demo/ui/pages/gyms_page.dart';
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

class MyApp extends StatefulWidget {

  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var storage;

  Future<Storage> loadDataBases() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    return storage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Storage>(
        future: loadDataBases(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          else {
            final Storage storage = snapshot.data!;

            return ChangeNotifierProvider<DBManager>(
              create: (context) => DBManager(storage),
              child: MaterialApp(
                title: 'WytwarzaniaBrakApp',
                theme: ThemeData(
                  primarySwatch: Colors.indigo,
                ),
                routes: {
                  HomePage.routeName: (context) =>
                      HomePage(title: 'WytwarzaniaBrak'),
                  FavoritesPage.routeName: (context) => const FavoritesPage(),
                  ExercisesPage.routeName: (context) => const ExercisesPage(),
                  MapPage.routeName: (context) => const MapPage(),
                  GymPage.routeName: (context) => const GymPage()
                },
                initialRoute: HomePage.routeName,
              ),
            );
          }
        });
  }
}
