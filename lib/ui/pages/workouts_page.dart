import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../models/exercise.dart';
import '../../models/workout.dart';

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
    for (int i = 0; i < 10; i++) {
      workoutList.add(new Workout(
          id: i.toString(),
          name: "Trening $i",
          exercises: [
            Tuple2(Exercise(name: "Ćwiczenie ${i}1"), 5),
            Tuple2(Exercise(name: "Ćwiczenie ${i}2"), 10),
            Tuple2(Exercise(name: "Ćwiczenie ${i}3"), 15)
          ],
          description: "Opis treningu nr. $i"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: workoutList.length,
          cacheExtent: 20.0,
          controller: ScrollController(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) => _WorkoutTile(
            workout: workoutList[index],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: _addWorkout,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        )
      ]),
    );
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
      subtitle: Text(workout.description),
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: workout.exercises.length,
            itemBuilder: (context, index) => ListTile(
                  trailing: Text(
                      "Powtórzenia: ${workout.exercises[index].item2.toString()}"),
                  title: Text(workout.exercises[index].item1.name),
                ))
      ],
    );
  }
}
