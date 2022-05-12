import 'package:flutter/material.dart';
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
                      final item = workoutList[index];
                      return _WorkoutTile(workout: item);
                    });
              }
            }));
  }

  void _addWorkout() {
    // TODO: Open a form for creating a new workout
  }
}

class _WorkoutTile extends StatelessWidget {
  final Workout workout;

  _WorkoutTile({required this.workout});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(workout.name),
      children: <Widget>[
        /*
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: workout.exercises.length,
            itemBuilder: (context, index) => ListTile(
                  trailing: Text(
                      "Powtórzenia: ${workout.exercises[index].item2.toString()}"),
                  title: Text(workout.exercises[index].item1.name),
                ))*/
      ],
    );
  }
}
