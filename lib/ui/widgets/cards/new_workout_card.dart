import 'package:flutter/material.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../models/exercise.dart';
import '../../../models/workout.dart';
import '../../../storage/dbmanager.dart';

class NewWorkoutCard extends StatefulWidget {
  const NewWorkoutCard(
      {Key? key, required this.cancelCallback, required this.submitCallback})
      : super(key: key);

  final VoidCallback cancelCallback;
  final VoidCallback submitCallback;

  @override
  _NewWorkoutState createState() => _NewWorkoutState();
}

class _NewWorkoutState extends State<NewWorkoutCard> {
  final nameController = TextEditingController();

  List<Exercise> _exercises = [];
  List<Exercise> _exercisesToShow = [];
  List<String> _bodyParts = [];

  List<String> _filterBodyParts = [];
  List<Exercise> _pickedExercises = [];

  Wrap w = new Wrap(spacing: 3.0, runSpacing: 3.0, children: []);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();

    return FutureBuilder<List<Exercise>>(
        future: dbManager.getAll<Exercise>(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            _exercises = snapshot.data!;
            if (_filterBodyParts.isEmpty)
              _exercisesToShow = _exercises;
            else
              _exercisesToShow = _exercises
                  .where(
                      (element) => _filterBodyParts.contains(element.bodyPart))
                  .toList();
            for (int i = 0; i < _pickedExercises.length; i++) {
              if (_exercisesToShow
                  .map((e) => e.name)
                  .toList()
                  .contains(_pickedExercises[i].name))
                _exercisesToShow.removeWhere(
                    (element) => element.name == _pickedExercises[i].name);
            }
            _bodyParts = _exercises.map((e) => e.bodyPart!).toSet().toList();

            return ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Workout name',
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: _bodyParts == null ? 0 : _bodyParts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                              //You need to make my child interactive
                              onTap: () => {
                                setState(() {
                                  if (_filterBodyParts
                                      .contains(_bodyParts[index]))
                                    _filterBodyParts.remove(_bodyParts[index]);
                                  else
                                    _filterBodyParts.add(_bodyParts[index]);
                                })
                              },
                              child: Container(
                                height: 50,
                                color:
                                    _filterBodyParts.contains(_bodyParts[index])
                                        ? Colors.green
                                        : Colors.red,
                                child: Center(
                                    child: Text(
                                  _bodyParts[index],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                              ),
                            );
                          }),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          _filterBodyParts = [];
                        })
                      },
                      child: Text('Reset body part filter'),
                    ),
                    Expanded(
                        child: Container(
                      height: 150,
                      child: ListView.builder(
                          itemCount: _exercisesToShow == null
                              ? 0
                              : _exercisesToShow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new GestureDetector(
                              //You need to make my child interactive
                              onTap: () => {
                                setState(() {
                                  if (!_pickedExercises
                                      .map((e) => e.name)
                                      .toList()
                                      .contains(_exercisesToShow[index].name))
                                    _pickedExercises.add(_exercisesToShow
                                        .where((element) =>
                                            element.name ==
                                            _exercisesToShow[index].name)
                                        .first);
                                })
                              },
                              child: Container(
                                height: 50,
                                color: Colors.blueAccent,
                                child: Center(
                                    child: Text(
                                  _exercisesToShow[index].name,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                              ),
                            );
                          }),
                    )),
                    SizedBox(height: 10),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _pickedExercises
                          .map((e) => _buildChip(e.name, Colors.white10))
                          .toList(),
                    ))),
                    //Expanded(
                    // child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              widget.cancelCallback();
                            }),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (nameController.text != "") {
                              int workoutId = (await dbManager
                                  .addToLocal<Workout>([
                                Workout(
                                    name: nameController.text,
                                    userDefined: true)
                              ]))[0];

                              List<WorkoutExercise> connections =
                                  _pickedExercises
                                      .map((e) => WorkoutExercise(
                                          workoutId: workoutId,
                                          exerciseId: e.id!,
                                          series: 1,
                                          reps: 1))   //TODO: Zamienić na możliwe do dodania
                                      .toList();
                              await dbManager
                                  .addToLocal<WorkoutExercise>(connections);

                              Fluttertoast.showToast(msg: "Workout added");
                              widget.submitCallback();
                            } else
                              Fluttertoast.showToast(
                                  msg: "Unspecified workout name");
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }
}
