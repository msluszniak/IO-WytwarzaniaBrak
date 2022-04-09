// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:provider/provider.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({Key? key}) : super(key: key);
  static const routeName = '/exercises';

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  bool isFavouriteEnabled = false;

  void toggleFavourite() {
    setState(() {
      isFavouriteEnabled = !isFavouriteEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    final appBar = AppBar(
      title: const Text('Exercises'),
      actions: [
        Spacer(),
        Expanded(
            child: Row(
          children: [
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: toggleFavourite,
              icon: isFavouriteEnabled
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              label: const Text('Favorites'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {},
              icon: const Icon(Icons.circle_outlined),
              label: const Text('Tab2'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {},
              icon: const Icon(Icons.circle_outlined),
              label: const Text('Tab3'),
            ),
            Spacer()
          ],
        )),
      ],
    );

    return Scaffold(
        appBar: appBar,
        body: FutureBuilder<List<Exercise>>(
            future: isFavouriteEnabled
                ? dbManager.getFavExercises()
                : dbManager.getExercises(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                final List<Exercise> favouritesList = snapshot.data!;

                return ListView.builder(
                    itemCount: favouritesList.length,
                    cacheExtent: 20.0,
                    controller: ScrollController(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      final item = favouritesList[index];
                      return ItemTile(item, onPressed: isFavouriteEnabled ? (){} : () {
                        dbManager.setFavourite(item.id!, !item.isFav);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(item.isFav
                                ? 'Added to favorites.'
                                : 'Removed from favorites.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      });
                    });
              }
            }));
  }
}

class ItemTile extends StatelessWidget {
  final Exercise item;
  final void Function() onPressed;

  const ItemTile(this.item, {required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[item.id! % Colors.primaries.length],
        ),
        title: Text(
          'Item ${item.id}',
          key: Key('text_${item.id!}'),
        ),
        trailing: IconButton(
          key: Key('icon_${item.id!}'),
          icon: item.isFav
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
