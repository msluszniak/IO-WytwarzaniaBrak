import 'package:floor/floor.dart';
import 'package:flutter_demo/models/workout.dart';

import 'abstract/base_join_model.dart';
import 'exercise.dart';

@Entity(primaryKeys: [
  'workoutId',
  'exerciseId'
], foreignKeys: [
  ForeignKey(
      childColumns: ['workoutId'], parentColumns: ['id'], entity: Workout, onDelete: ForeignKeyAction.noAction, onUpdate: ForeignKeyAction.noAction),
  ForeignKey(
      childColumns: ['exerciseId'], parentColumns: ['id'], entity: Exercise, onDelete: ForeignKeyAction.noAction, onUpdate: ForeignKeyAction.noAction)
])
class WorkoutExercise extends BaseJoinModel {
  final int workoutId;
  final int exerciseId;

  WorkoutExercise({required this.workoutId, required this.exerciseId});

  WorkoutExercise.fromJson(Map<String, dynamic> json)
      : workoutId = json['workoutId'],
        exerciseId = json['exerciseId'];
}
