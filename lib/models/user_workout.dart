import 'package:floor/floor.dart';

import 'abstract/base_id_model.dart';

@entity
class UserWorkout extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isFavorite;
  final bool userDefined;

  UserWorkout(
      {this.id,
        required this.name,
        this.isFavorite = false,
        this.userDefined = true});

  UserWorkout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isFavorite = false,
        userDefined = true;
}
