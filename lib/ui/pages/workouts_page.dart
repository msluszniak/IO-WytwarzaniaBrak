import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/abstract/base_id_model.dart';
import '../../models/abstract/base_model.dart';
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
          FutureBuilder<List<BaseModel>>(
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
                            FutureBuilder<List<BaseIdModel>>(
                                future: dbManager
                                    .getJoined<Workout, Exercise>(workout.id!),
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
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                              title: Text(
                                                  exerciseList[index].name),
                                            ));
                                  }
                                })
                          ],
                        );
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
}
