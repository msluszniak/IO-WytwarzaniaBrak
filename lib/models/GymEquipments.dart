import 'package:floor/floor.dart';
import 'package:flutter_demo/models/equipment.dart';

import 'abstract/base_join_model.dart';
import 'gym.dart';

@Entity(primaryKeys: [
  'gymId',
  'equipmentId'
], foreignKeys: [
  ForeignKey(
      childColumns: ['gymId'], parentColumns: ['id'], entity: Gym, onDelete: ForeignKeyAction.noAction, onUpdate: ForeignKeyAction.noAction),
  ForeignKey(
      childColumns: ['equipmentId'], parentColumns: ['id'], entity: Equipment, onDelete: ForeignKeyAction.noAction, onUpdate: ForeignKeyAction.noAction)
])
class GymEquipment extends BaseJoinModel {
  final int gymId;
  final int equipmentId;

  GymEquipment({required this.gymId, required this.equipmentId});

  GymEquipment.fromJson(Map<String, dynamic> json)
      : gymId = json['gymId'],
        equipmentId = json['equipmentId'];
}
