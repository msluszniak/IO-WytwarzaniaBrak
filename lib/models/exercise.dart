import 'package:floor/floor.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';

@entity
class Exercise extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int equipmentId;
  final String? bodyPart;
  final String? description;
  final bool isFavorite;

  Exercise(
      {this.id,
      required this.name,
      required this.equipmentId,
      this.bodyPart,
      this.description,
      this.isFavorite = false});

  Exercise.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        equipmentId = json['equipmentId'],
        bodyPart = json['bodyPart'],
        description = json['description'],
        isFavorite = false;
}
