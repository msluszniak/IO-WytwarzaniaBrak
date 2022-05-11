import 'package:floor/floor.dart';

import '../../models/exercise.dart';


@dao
abstract class ExerciseDao  {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateExercises(List<Exercise> person);

  @Query("UPDATE Exercise SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateExerciseFavorites(List<int> favoriteIds);

  @Query("SELECT * FROM Exercise")
  Future<List<Exercise>> getExercises();

  @insert
  Future<void> addExercise(Exercise exercise);

  @Query("SELECT * FROM Exercise WHERE isFavorite")
  Future<List<Exercise>> getFavExercises();

  @Query("UPDATE Exercise SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> setFavourite(int id, bool isFavorite);
}