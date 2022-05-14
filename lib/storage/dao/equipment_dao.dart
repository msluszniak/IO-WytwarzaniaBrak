import 'package:floor/floor.dart';
import 'package:flutter_demo/models/equipment.dart';

@dao
abstract class EquipmentDao{
  @insert
  Future<void> add(Equipment equipment);

  @Query("SELECT * FROM Equipments")
  Future<List<Equipment>> getAll();
}