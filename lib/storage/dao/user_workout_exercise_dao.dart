import 'package:floor/floor.dart';

import '../../models/user_workout_exercises.dart';

@dao
abstract class UserWorkoutExerciseDao {
  @insert
  Future<List<int>> add(List<UserWorkoutExercise> workout);

  @Query("SELECT * FROM UserWorkoutExercise")
  Future<List<UserWorkoutExercise>> getAll();
}