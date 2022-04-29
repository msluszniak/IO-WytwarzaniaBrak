import 'package:tuple/tuple.dart';

import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<Tuple2<Exercise, int>> exercises;
  final String description;

  Workout(
      {required this.id,
      required this.name,
      required this.exercises,
      required this.description});
}
