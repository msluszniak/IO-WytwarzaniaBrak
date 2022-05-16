import 'package:floor/floor.dart';
import 'package:flutter_demo/models/base_model.dart';
import 'package:flutter_demo/storage/dao/equipment_dao.dart';

@entity
class Equipment extends BaseModel {

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Equipment(
      {this.id,
        required this.name,
        });

  Equipment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}