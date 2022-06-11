import 'package:flutter/material.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_demo/models/planned_workout.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:provider/provider.dart';

import '../../../models/abstract/base_model.dart';
import '../../../models/workout.dart';
import '../../../models/workout_exercises.dart';

class GymsForWorkout extends StatelessWidget {
  final PlannedWorkout plannedWorkout;
  final Workout workout;

  const GymsForWorkout({Key? key, required this.plannedWorkout, required this.workout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout plan'),
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: plannedWorkout.gymsToVisit.length,
              cacheExtent: 20.0,
              controller: ScrollController(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                final gym = plannedWorkout.gymsToVisit[index];
                final List<Exercise> exercisesOnGym = plannedWorkout.exercisesOnGyms[index];
                return FutureBuilder(
                  future: Future.wait([
                    dbManager.getJoined<Workout, WorkoutExercise>(workout.id!),
                  ]),
                  builder: (context, AsyncSnapshot<List<List<BaseModel>>> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      final List<WorkoutExercise> workoutExerciseList =
                      snapshot.data![0].cast<WorkoutExercise>();
                      return ExpansionTile(
                        title: Text(gym.name + "(" + gym.address.toString() + ")"),
                          subtitle:
                          Text(exercisesOnGym.length.toString(), style: TextStyle(color: Colors.black12.withOpacity(0.7))),
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: exercisesOnGym.length,
                                          itemBuilder: (context, index) {
                                            final exercise = exercisesOnGym[index];
                                            final workoutExercise =
                                            workoutExerciseList.firstWhere((e) => e.exerciseId == exercise.id);
                                            final repTime = exercise.repTime;
                                            return ListTile(
                                              title: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Text(exercise.name),
                                                    SizedBox(width: 10),
                                                    Chip(
                                                      labelPadding: EdgeInsets.all(2.0),
                                                      label: Text(
                                                        "Series: " + workoutExercise.series.toString(),
                                                      ),
                                                      backgroundColor: Colors.white10,
                                                      elevation: 6.0,
                                                      shadowColor: Colors.grey[60],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Chip(
                                                      labelPadding: EdgeInsets.all(2.0),
                                                      label: Text(
                                                          "Reps: " + workoutExercise.reps.toString()
                                                      ),
                                                      backgroundColor: Colors.white10,
                                                      elevation: 6.0,
                                                      shadowColor: Colors.grey[60],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ]);
                              }
                            });
                      }),

    ]));
  }
}



