import 'package:floor/floor.dart';
import 'package:flutter_demo/models/user_workout.dart';

import 'abstract/base_join_model.dart';
import 'exercise.dart';

@Entity(primaryKeys: [
  'workoutId',
  'exerciseId'
], foreignKeys: [
  ForeignKey(
      childColumns: ['workoutId'], parentColumns: ['id'], entity: UserWorkout, onDelete: ForeignKeyAction.cascade, onUpdate: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['exerciseId'], parentColumns: ['id'], entity: Exercise, onDelete: ForeignKeyAction.cascade, onUpdate: ForeignKeyAction.cascade)
])
class UserWorkoutExercise extends BaseJoinModel {
  final int workoutId;
  final int exerciseId;

  UserWorkoutExercise({required this.workoutId, required this.exerciseId});

  UserWorkoutExercise.fromJson(Map<String, dynamic> json)
      : workoutId = json['workoutId'],
        exerciseId = json['exerciseId'];
}