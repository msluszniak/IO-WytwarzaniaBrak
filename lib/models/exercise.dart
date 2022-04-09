import 'package:floor/floor.dart';

@entity
class Exercise {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isFav;

  Exercise({ this.id,
    required this.name, this.isFav=false});
}