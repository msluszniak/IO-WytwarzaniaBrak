import 'package:floor/floor.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';

@entity
class Workout extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isFavorite;
  final bool userDefined;

  Workout({this.id, required this.name, this.isFavorite = false, this.userDefined = false});

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isFavorite = false,
        userDefined = false;
}
