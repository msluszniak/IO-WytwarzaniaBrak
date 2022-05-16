import 'package:flutter/material.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise selectedExercise;

  const ExerciseCard({Key? key, required this.selectedExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();
    Future<List<Equipment>> equipment =
        dbManager.getJoined<Exercise, Equipment>(selectedExercise.id!);

    return new Scaffold(
      body: Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              horizontalTitleGap: 16.0,
              leading: Icon(Icons.fitness_center),
              title: Text(selectedExercise.name),
              subtitle: Row(
                children: [
                  FutureBuilder<List<Equipment>>(
                      future: equipment,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          final List<Equipment> equipmentList = snapshot.data!;
                          return Text(
                            " " + equipmentList.first.name + "\n",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }
                      }),
                  Expanded(
                      child: Text(selectedExercise.description!,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontStyle: FontStyle.italic))),
                ],
              ),
            ),
            Divider(
                height: 20,
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
