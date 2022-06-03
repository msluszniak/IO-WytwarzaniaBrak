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
  Future<void> updateAll(List<Gym> gyms);

  @Query("DELETE FROM Gym WHERE id NOT IN (:keptIds)")
  Future<void> deleteRemoved(List<int> keptIds);

  Future<void> updateFromDatabase(List<Gym> gyms) async {
    final keptIds = gyms.map((e) => e.id!).toList();
    this.deleteRemoved(keptIds);
    this.updateAll(gyms);
  }

  @Query("UPDATE Gym SET isFavorite=1 WHERE id in (:favoriteIds)")
  Future<void> updateFavorites(List<int> favoriteIds);
}