import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/gyms_page.dart';
import 'package:flutter_demo/ui/pages/favorites.dart';
import 'package:flutter_demo/ui/pages/exercises_page.dart';
import 'package:flutter_demo/ui/pages/map_page.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
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
            onTap: () => Navigator.pushNamed(context, MapPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Exercises'),
            onTap: () => Navigator.pushNamed(context, ExercisesPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () => Navigator.pushNamed(context, FavoritesPage.routeName),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Gyms'),
            onTap: () => Navigator.pushNamed(context, GymPage.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
