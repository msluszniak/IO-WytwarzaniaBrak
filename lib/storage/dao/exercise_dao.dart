import 'package:floor/floor.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:tuple/tuple.dart';
import '../../models/workout.dart';


@dao
abstract class ExerciseDao{
  @insert
  Future<void> add(Exercise exercise);

  @Query("UPDATE Exercise SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> addFavorite(int id, bool isFavorite);

  @Query("SELECT * FROM Exercise")
  Future<List<Exercise>> getAll();

  @Query("SELECT * FROM Exercise WHERE isFavorite")
  Future<List<Exercise>> getFavorite();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Exercise> person);

  @Query("UPDATE Exercise SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateFavorites(List<int> favoriteIds);

  @Query("SELECT * FROM Workout WHERE id IN (SELECT workoutId FROM WorkoutExercise WHERE exerciseId = :exerciseId)")
  Future<List<Workout>> getJoinedWorkouts(int exerciseId);

  @Query("SELECT * FROM Equipment WHERE id IN (SELECT equipmentId FROM Exercise WHERE id = :exerciseId)")
  Future<List<Equipment>> getJoinedEquipments(int exerciseId);
}