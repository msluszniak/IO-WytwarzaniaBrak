import 'package:floor/floor.dart';

import '../../models/exercise.dart';
import '../../models/user_workout.dart';

@dao
abstract class UserWorkoutDao {
  @insert
  Future<List<int>> add(List<UserWorkout> userWorkout);

  @Query("UPDATE UserWorkout SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> addFavorite(int id, bool isFavorite);

  @Query("SELECT * FROM UserWorkout")
  Future<List<UserWorkout>> getAll();

  @Query("SELECT * FROM UserWorkout WHERE isFavorite")
  Future<List<UserWorkout>> getFavorite();

  @Query("SELECT * FROM Exercise WHERE id IN (SELECT exerciseId FROM UserWorkoutExercise WHERE workoutId = :workoutId)")
  Future<List<Exercise>> getJoinedExercises(int workoutId);
}