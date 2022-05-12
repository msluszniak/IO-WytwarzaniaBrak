import 'package:floor/floor.dart';

import '../../models/gym.dart';

@dao
abstract class GymDao{
  @insert
  Future<void> add(Gym gym);

  @Query("UPDATE Gym SET isFavorite=:isFavorite WHERE id=:id")
  Future<void> addFavorite(int id, bool isFavorite);

  @Query("SELECT * FROM Gym")
  Future<List<Gym>> getAll();

  @Query("SELECT * FROM Gym WHERE isFavorite")
  Future<List<Gym>> getFavorite();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Gym> person);

  @Query("UPDATE Gym SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateFavorites(List<int> favoriteIds);
}