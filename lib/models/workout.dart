import 'package:floor/floor.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';

@entity
class Workout extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isFavorite;

  Workout({this.id, required this.name, this.isFavorite = false});

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isFavorite = false;
}
