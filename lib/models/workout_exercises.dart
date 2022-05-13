import 'package:floor/floor.dart';
import 'package:flutter_demo/models/workout.dart';

import 'exercise.dart';

@Entity(primaryKeys: [
  'workoutId',
  'exerciseId'
], foreignKeys: [
  ForeignKey(
      childColumns: ['workoutId'], parentColumns: ['id'], entity: Workout),
  ForeignKey(
      childColumns: ['exerciseId'], parentColumns: ['id'], entity: Exercise)
])
class WorkoutExercise {
  final int workoutId;
  final int exerciseId;

  WorkoutExercise({required this.workoutId, required this.exerciseId});

  WorkoutExercise.fromJson(Map<String, dynamic> json)
      : workoutId = json['workoutId'],
        exerciseId = json['exerciseId'];
}
