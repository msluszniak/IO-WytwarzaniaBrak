import 'package:flutter/material.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:flutter_demo/ui/widgets/cards/exercise_card.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../models/equipment.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({Key? key}) : super(key: key);
  static const routeName = '/exercises';

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  bool isFavouriteEnabled = false;

  List<Exercise> selectedExercises = [];
  List<String> selectedBodyParts = [];

  void toggleFavourite() {
    setState(() {
      isFavouriteEnabled = !isFavouriteEnabled;
    });
  }

  void applyBodyPartFilter(List<Exercise> allExercises) {
    if (this.selectedBodyParts.isEmpty) {
      this.selectedExercises = allExercises;
    } else {
      this.selectedExercises = allExercises
          .where(
              (element) => this.selectedBodyParts
              .contains(element.bodyPart)
      ).toList();
    }
    this.selectedExercises.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return FutureBuilder<List<Exercise>>(
        future: isFavouriteEnabled
            ? dbManager.getFavorites<Exercise>()
            : dbManager.getAll<Exercise>(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final List<Exercise> favouritesList = snapshot.data!;
            this.applyBodyPartFilter(favouritesList);
            final List<String> allBodyParts = favouritesList.map((e) => e.bodyPart!).toSet().toList();

            final appBar = AppBar(
              title: const Text('Exercises'),
              actions: [
                TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.white),
                  onPressed: toggleFavourite,
                  icon: isFavouriteEnabled
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  label: const Text('Favorites'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.white),
                  icon: const Icon(Icons.filter_alt),
                  label: const Text('Body parts'),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) {
                        return  MultiSelectDialog(
                          initialValue: this.selectedBodyParts,
                          items: allBodyParts.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          title: Text("Body parts"),
                          onConfirm: (values) {
                            this.selectedBodyParts = values.map((e) => e.toString()).toList();
                            this.setState(() {
                              this.applyBodyPartFilter(favouritesList);
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );

            return Scaffold(
            appBar: appBar,
            body: ListView.builder(
                itemCount: this.selectedExercises.length,
                cacheExtent: 20.0,
                controller: ScrollController(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) {
                  final item = this.selectedExercises[index];
                  return ItemTile(item,

                      ///this version of onTap servers purely testing purposes, when tapped tile prints name of proper equipment
                      onTap: () async {
                        final Equipment equipment = (await dbManager
                                .getJoined<Exercise, Equipment>(item.id!)).first;

                        print(equipment.name);
                      },
                      onFavoritePressed: isFavouriteEnabled
                          ? () {}
                          : () {
                              dbManager.setFavourite<Exercise>(
                                  item.id!, !item.isFavorite);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(!item.isFavorite
                                      ? 'Added to favorites.'
                                      : 'Removed from favorites.'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            });
                }));
          }
        });
  }
}

class ItemTile extends StatelessWidget {
  final Exercise item;
  final void Function() onFavoritePressed;

  final dynamic Function() onTap;

  const ItemTile(this.item,
      {required this.onFavoritePressed, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[(item.bodyPart.hashCode + item.bodyPart.toString().length) % Colors.primaries.length],
        ),
        title: Text(
          item.name,
          key: Key(item.id.toString()),
        ),
        subtitle: Text(
          item.bodyPart.toString(),
          style: TextStyle(color: Colors.black12.withOpacity(0.7)),
          key: Key(item.id.toString()),
        ),
        onTap: () => Navigator.push(
            context,
          MaterialPageRoute(
              builder: (context) {
                return new ExerciseCard(selectedExercise: item);
              },
              fullscreenDialog: true,
            ),
        ),
        trailing: IconButton(
          key: Key('icon_${item.id!}'),
          icon: item.isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: this.onFavoritePressed,
        ),
      ),
    );
  }
}
