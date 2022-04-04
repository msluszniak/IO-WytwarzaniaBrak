// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/models/favorites.dart';
import 'package:flutter_demo/ui/pages/favorites.dart';

class ExercisesPage extends StatelessWidget {
  static const routeName = '/exercises';

  const ExercisesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: [
          Spacer(),
          Expanded(
              child: Row(
            children: [
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, FavoritesPage.routeName);
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('Favorites'),
              ),
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  // Add route
                },
                icon: const Icon(Icons.circle_outlined),
                label: const Text('Tab2'),
              ),
              Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  // Add route
                },
                icon: const Icon(Icons.circle_outlined),
                label: const Text('Tab3'),
              ),
              Spacer()
            ],
          )),
        ],
      ),
      body: ListView.builder(
        itemCount: 100,
        cacheExtent: 20.0,
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ItemTile(index),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile(this.itemNo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesList = context.watch<Favorites>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Item $itemNo',
          key: Key('text_$itemNo'),
        ),
        trailing: IconButton(
          key: Key('icon_$itemNo'),
          icon: favoritesList.items.contains(itemNo)
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: () {
            !favoritesList.items.contains(itemNo)
                ? favoritesList.add(itemNo)
                : favoritesList.remove(itemNo);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(favoritesList.items.contains(itemNo)
                    ? 'Added to favorites.'
                    : 'Removed from favorites.'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
