import 'package:floor/floor.dart';

import '../../models/workout_exercises.dart';

@dao
abstract class WorkoutExerciseDao {
  @insert
  Future<void> add(WorkoutExercise workout);

  @Query("SELECT * FROM WorkoutExercise")
  Future<List<WorkoutExercise>> getAll();

  @Query("DELETE FROM WorkoutExercise")
  Future<void> clearAll();

  @insert
  Future<void> addAll(List<WorkoutExercise> workoutExercises);

  Future<void> updateAll(List<WorkoutExercise> workoutExercises) async {
    this.clearAll();
    this.addAll(workoutExercises);
  }
}