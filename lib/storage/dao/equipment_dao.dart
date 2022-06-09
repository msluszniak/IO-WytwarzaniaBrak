import 'package:floor/floor.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';


@dao
abstract class EquipmentDao{
  @insert
  Future<int> add(Equipment equipment);

  @insert
  Future<List<int>> addAll(List<Equipment> equipments);
  
  @Query("SELECT * FROM Equipment")
  Future<List<Equipment>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Equipment> equipments);

  @Query("DELETE FROM Equipment WHERE id NOT IN (:keptIds)")
  Future<void> deleteRemoved(List<int> keptIds);

  Future<void> updateFromDatabase(List<Equipment> equipments) async {
    final keptIds = equipments.map((e) => e.id!).toList();
    this.deleteRemoved(keptIds);
    this.updateAll(equipments);
  }

  @Query("SELECT * FROM Exercise WHERE equipmentId = :equipmentId")
  Future<List<Exercise>> getJoinedExercises(int equipmentId);
}