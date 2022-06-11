import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/abstract/base_id_model.dart';
import '../../models/exercise.dart';
import '../../models/workout.dart';
import '../../storage/dbmanager.dart';
import '../widgets/cards/new_workout_card.dart';

class WorkoutsPage extends StatefulWidget {
  static const routeName = '/workouts';

  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class _WorkoutsState extends State<WorkoutsPage> {
  late final List<Workout> workoutList = [];

  bool _formVisible = false;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Workout>>(
              future: dbManager.getAll<Workout>(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  final List<Workout> workoutList =
                      snapshot.data!;

                  return ListView.builder(
                      itemCount: workoutList.length,
                      cacheExtent: 20.0,
                      controller: ScrollController(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final workout = workoutList[index];
                        return FutureBuilder(
                            future: Future.wait([
                              dbManager.getJoined<Workout, Exercise>(workout.id!),
                              dbManager.getJoined<Workout, WorkoutExercise>(workout.id!),
                            ]),
                            builder: (context, AsyncSnapshot<List<List<BaseModel>>> snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                final List<Exercise> exerciseList = snapshot.data![0].cast<Exercise>();
                                final List<WorkoutExercise> workoutExerciseList =
                                    snapshot.data![1].cast<WorkoutExercise>();

                                final List<String> bodyParts = getWorkoutTags(exerciseList);
                                String bodyPartsString = bodyParts.toString().replaceAll("[", "").replaceAll("]", "");
                                return ExpansionTile(
                                    title: Text(workout.name),
                                    subtitle:
                                        Text(bodyPartsString, style: TextStyle(color: Colors.black12.withOpacity(0.7))),
                                    children: <Widget>[
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: exerciseList.length,
                                          itemBuilder: (context, index) {
                                            final exercise = exerciseList[index];
                                            final workoutExercise =
                                                workoutExerciseList.firstWhere((e) => e.exerciseId == exercise.id);

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
                                          })
                                    ]);
                              }
                            });
                      });
                }
              }),
          Container(
              child: Visibility(
            child: NewWorkoutCard(
              cancelCallback: () {
                setState(() {
                  _formVisible = !_formVisible;
                });
              },
              submitCallback: () {
                setState(() {
                  _formVisible = !_formVisible;
                });
              },
            ),
            visible: this._formVisible,
          )),
          Positioned(
            right: 20,
            bottom: 20,
            child: Visibility(
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _formVisible = !_formVisible;
                  });
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
              visible: !this._formVisible,
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _planWorkoutButton(List<Exercise> workoutExercises) {
    return ElevatedButton.icon(
      onPressed: () async {
        List<int> exerciseIds = workoutExercises.map((e) => e.id!).toList();
        PlannedWorkout plannedWorkout = await ServerConnection.getPlannedWorkout(exerciseIds);
        Fluttertoast.showToast(msg: plannedWorkout.toString());
      },
      icon: Icon(
        Icons.arrow_circle_right,
        size: 24.0,
      ),
      label: Text('Plan workout'),
    );
  }
}
