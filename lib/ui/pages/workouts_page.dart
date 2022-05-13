import 'package:flutter/material.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:provider/provider.dart';

import '../../models/base_model.dart';
import '../../models/exercise.dart';
import '../../models/workout.dart';
import '../../storage/dbmanager.dart';

class WorkoutsPage extends StatefulWidget {
  static const routeName = '/workouts';

  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<WorkoutsPage> {
  late final List<Workout> workoutList = [];

  @override
  void initState() {
    super.initState();

    // TODO : ładowanie z local storage
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
        ),
        body: FutureBuilder<List<BaseModel>>(
            future: dbManager.getAll<Workout>(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                final List<Workout> workoutList =
                    snapshot.data!.cast<Workout>();

                return ListView.builder(
                    itemCount: workoutList.length,
                    cacheExtent: 20.0,
                    controller: ScrollController(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      final workout = workoutList[index];
                      return ExpansionTile(
                        title: Text(workout.name),
                        children: <Widget>[
                          FutureBuilder<List<Exercise>>(
                              future:
                                  dbManager.getWorkoutExercises(workout.id!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  final List<Exercise> exerciseList =
                                      snapshot.data!.cast<Exercise>();

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: exerciseList.length,
                                      itemBuilder: (context, index) => ListTile(
                                            title:
                                                Text(exerciseList[index].name),
                                          ));
                                }
                              }),
                        ],
                      );
                    });
              }
            }));
  }

  void _addWorkout() {
    // TODO: Open a form for creating a new workout
  }
}
