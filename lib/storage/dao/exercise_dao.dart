import 'package:floor/floor.dart';

import '../../models/exercise.dart';


@dao
abstract class ExerciseDao  {
  @Query("SELECT * FROM Exercise WHERE isFav")
  Future<List<Exercise>> getFavExercises();

  @Query("SELECT * FROM Exercise")
  Future<List<Exercise>> getExercises();

  @insert
  Future<void> addExercise(Exercise exercise);

  @Query("UPDATE Exercise SET isFav=:isFav WHERE id=:id")
  Future<void> setFavourite(int id, bool isFav);


}