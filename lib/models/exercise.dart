import 'package:floor/floor.dart';

@entity
class Exercise {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String equipment;
  final String bodyPart;
  final bool isFav;

  Exercise(
      {this.id,
      required this.name,
      required this.equipment,
      required this.bodyPart,
      this.isFav = false});
}
