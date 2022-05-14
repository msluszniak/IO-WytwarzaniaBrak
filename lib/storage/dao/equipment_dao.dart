import 'package:floor/floor.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';

@dao
abstract class EquipmentDao{
  @insert
  Future<void> add(Equipment equipment);

  @Query("SELECT * FROM Equipment")
  Future<List<Equipment>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<Equipment> equipments);

  @Query("SELECT * FROM Exercise WHERE equipmentId = :equipmentId")
  Future<List<Exercise>> getJoinedExercises(int equipmentId);
}