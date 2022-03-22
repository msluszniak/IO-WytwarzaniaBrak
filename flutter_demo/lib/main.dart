import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/map_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/screens/home_page.dart';
import 'package:flutter_demo/screens/favorites.dart';
import 'package:flutter_demo/models/favorites.dart';
import 'package:flutter_demo/screens/list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        routes: {
          MyHomePage.routeName: (context) =>
              MyHomePage(title: 'Flutter Demo Home Page'),
          FavoritesPage.routeName: (context) => const FavoritesPage(),
          ListPage.routeName: (context) => const ListPage(),
          MapPage.routeName: (context) => const MapPage()
        },
        initialRoute: MyHomePage.routeName,
      ),
    );
  }
}
