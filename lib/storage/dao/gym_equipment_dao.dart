import 'package:floor/floor.dart';

import '../../models/GymEquipments.dart';

@dao
abstract class GymEquipmentDao {
  @insert
  Future<int> add(GymEquipment gymEquipment);

  @insert
  Future<List<int>> addAll(List<GymEquipment> gymEquipments);

  @Query("SELECT * FROM GymEquipment")
  Future<List<GymEquipment>> getAll();

  @Query("SELECT * FROM GymEquipment WHERE gymId = :gymId")
  Future<List<GymEquipment>> getAllWithGym(int gymId);

  @Query("SELECT * FROM GymEquipment WHERE equipmentId = :equipmentId")
  Future<List<GymEquipment>> getAllWithEquipment(int equipmentId);

  @Query("DELETE FROM GymEquipment")
  Future<void> clearAll();

  Future<void> updateAll(List<GymEquipment> gymEquipments) async {
    this.clearAll();
    this.addAll(gymEquipments);
  }
}