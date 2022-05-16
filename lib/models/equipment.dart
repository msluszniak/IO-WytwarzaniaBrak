import 'package:floor/floor.dart';
import 'abstract/base_id_model.dart';

@entity
class Equipment extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Equipment({
    this.id,
    required this.name,
  });

  Equipment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
