import 'package:floor/floor.dart';

import '../../models/workout.dart';

@dao
abstract class WorkoutDao{
  @insert
  Future<void> add(Workout workout);

  @Query("UPDATE Workout SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> addFavorite(int id, bool isFavorite);

  @Query("SELECT * FROM Workout")
  Future<List<Workout>> getAll();

  @Query("SELECT * FROM Workout WHERE isFavorite")
  Future<List<Workout>> getFavorite();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Workout> person);

  @Query("UPDATE Workout SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateFavorites(List<int> favoriteIds);
}