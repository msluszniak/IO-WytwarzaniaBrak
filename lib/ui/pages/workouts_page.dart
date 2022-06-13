import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/cards/gyms_for_workout.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

import '../../backend/server_connection.dart';
import '../../models/abstract/base_model.dart';
import '../../models/exercise.dart';
import '../../models/planned_workout.dart';
import '../../models/workout.dart';
import '../../models/workout_exercises.dart';
import '../../storage/dbmanager.dart';
import '../widgets/cards/new_workout_card.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WorkoutsPage extends StatefulWidget {
  static const routeName = '/workouts';

  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();
}

class LoadedData {
  final List<Workout> workoutList;
  final List<List<String>> bodyParts;

  LoadedData({
    required this.workoutList,
    required this.bodyParts
  });

  static Future<LoadedData> load(DBManager dbManager) async {
    final workouts = await dbManager.getAll<Workout>();
    final bodyParts = await Future.wait(workouts.map((e) => getWorkoutTagsViaManager(e, dbManager)));

    return LoadedData(workoutList: workouts, bodyParts: bodyParts);
  }
}



class _WorkoutsState extends State<WorkoutsPage> {
  late final List<Workout> workoutList = [];

  bool _formVisible = false;

  List<String> selectedBodyParts = [];
  List<Workout> selectedWorkouts = [];

  @override
  void initState() {
    super.initState();
  }

  void applyBodyPartFilter(List<Workout> allWorkouts, List<List<String>> workoutsBodyParts) {
    if (this.selectedBodyParts.isEmpty) {
      this.selectedWorkouts = allWorkouts;
    } else {
      this.selectedWorkouts = zip([allWorkouts, workoutsBodyParts])
          .where((pair) {
            final bodyParts = (pair[1] as List<String>);
            return this.selectedBodyParts.every((element) => bodyParts.contains(element));
          }).map(
              (e) => e[0] as Workout
      ).toList();
    }
  }



  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return FutureBuilder<LoadedData>(
        future: LoadedData.load(dbManager),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final LoadedData data = snapshot.data!;

            final workoutList = data.workoutList;
            final workoutsBodyParts = data.bodyParts;
            final allBodyParts = workoutsBodyParts.expand((element) => element).toSet().toList();

            this.applyBodyPartFilter(workoutList, workoutsBodyParts);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Workouts'),
                actions: [
                  Spacer(),
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
                                this.applyBodyPartFilter(workoutList, workoutsBodyParts);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  ListView.builder(
                      itemCount: this.selectedWorkouts.length,
                      cacheExtent: 20.0,
                      controller: ScrollController(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final workout = this.selectedWorkouts[index];
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
                                          }),
                                      _planWorkoutButton(exerciseList, workout)
                                    ]);
                              }
                            });
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
        });


  }

  ElevatedButton _planWorkoutButton(List<Exercise> workoutExercises, Workout workout1) {
    return ElevatedButton.icon(
      onPressed: () async {
        List<int> exerciseIds = workoutExercises.map((e) => e.id!).toList();
        PlannedWorkout plannedWorkout1 = await ServerConnection.getPlannedWorkout(exerciseIds);
        Fluttertoast.showToast(msg: plannedWorkout1.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new GymsForWorkout(plannedWorkout: plannedWorkout1, workout: workout1);
            },
            fullscreenDialog: true,
          ),
        );
      },
      icon: Icon(
        Icons.arrow_circle_right,
        size: 24.0,
      ),
      label: Text('Plan workout'),
    );
  }
}
