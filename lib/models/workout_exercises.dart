import 'package:floor/floor.dart';
import 'package:flutter_demo/models/workout.dart';

import 'abstract/base_join_model.dart';
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
class WorkoutExercise extends BaseJoinModel {
  final int workoutId;
  final int exerciseId;
  final int series;
  final int reps;

  WorkoutExercise({required this.workoutId, required this.exerciseId, required this.series, required this.reps});

  WorkoutExercise.fromJson(Map<String, dynamic> json)
      : workoutId = json['workoutId'],
        exerciseId = json['exerciseId'],
        series = json['series'],
        reps = json['reps'];
}
