import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/gyms_page.dart';
import 'package:flutter_demo/ui/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/ui/pages/home_page.dart';
import 'package:flutter_demo/ui/pages/favorites.dart';
import 'package:flutter_demo/models/favorites.dart';
import 'package:flutter_demo/ui/pages/exercises_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
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
}
