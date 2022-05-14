import 'package:floor/floor.dart';
import 'package:flutter_demo/models/abstract/base_model.dart';

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