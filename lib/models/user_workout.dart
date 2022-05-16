import 'package:floor/floor.dart';

import 'abstract/base_id_model.dart';

@entity
class UserWorkout extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isFavorite;

  UserWorkout({this.id, required this.name, this.isFavorite = false});

  UserWorkout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isFavorite = false;
}