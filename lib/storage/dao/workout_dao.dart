import 'package:floor/floor.dart';

import '../../models/exercise.dart';
import '../../models/workout.dart';

@dao
abstract class WorkoutDao {
  @insert
  Future<int> add(Workout workout);

  @insert
  Future<List<int>> addAll(List<Workout> workouts);

  @Query("UPDATE Workout SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> addFavorite(int id, bool isFavorite);

  @Query("SELECT * FROM Workout")
  Future<List<Workout>> getAll();

  @Query("SELECT * FROM Workout WHERE isFavorite")
  Future<List<Workout>> getFavorite();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Workout> workouts);

  @Query("DELETE FROM Workout WHERE id NOT IN (:keptIds)")
  Future<void> deleteRemoved(List<int> keptIds);

  Future<void> updateFromDatabase(List<Workout> workouts) async {
    final keptIds = workouts.map((e) => e.id!).toList();
    this.deleteRemoved(keptIds);
    this.updateAll(workouts);
  }

  @Query("UPDATE Workout SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateFavorites(List<int> favoriteIds);

  @Query("SELECT * FROM Exercise WHERE id IN (SELECT exerciseId FROM WorkoutExercise WHERE workoutId = :workoutId)")
  Future<List<Exercise>> getJoinedExercises(int workoutId);

  @Query("SELECT * FROM Workout WHERE userDefined = 1")
  Future<List<Workout>> getLocal();

  @Query("DELETE FROM Workout WHERE userDefined = 1")
  Future<void> removeLocal();
}
