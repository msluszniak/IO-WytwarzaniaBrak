import 'package:floor/floor.dart';

import '../../models/workout_exercises.dart';

@dao
abstract class WorkoutExerciseDao {
  @insert
  Future<int> add(WorkoutExercise workout);

  @insert
  Future<List<int>> addAll(List<WorkoutExercise> workoutExercises);

  @Query("SELECT * FROM WorkoutExercise")
  Future<List<WorkoutExercise>> getAll();

  @Query("SELECT * FROM WorkoutExercise WHERE workoutId = :workoutId")
  Future<List<WorkoutExercise>> getAllWithWorkout(int workoutId);

  @Query("SELECT * FROM WorkoutExercise WHERE exerciseId = :exerciseId")
  Future<List<WorkoutExercise>> getAllWithExercise(int exerciseId);

  @Query("DELETE FROM WorkoutExercise")
  Future<void> clearAll();

  Future<void> updateAll(List<WorkoutExercise> workoutExercises) async {
    this.clearAll();
    this.addAll(workoutExercises);
  }

  @Query("DELETE FROM WorkoutExercise WHERE workoutId IN (SELECT id FROM Workout WHERE userDefined = 1)")
  Future<void> removeLocal();
}