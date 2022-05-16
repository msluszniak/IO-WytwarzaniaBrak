import 'package:floor/floor.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';

import '../storage/dbmanager.dart';
import 'exercise.dart';

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

List<String> getWorkoutTags(List<Exercise> exercises) {
  final bodyParts = exercises.map((value) => value.bodyPart);

  Map<String, int> counter = Map();

  for (var bodyPart in bodyParts) {
    counter.putIfAbsent(bodyPart!, () => 0);
    counter[bodyPart] = counter[bodyPart]! + 1;
  }

  final int minimalTagPresence = (0.4 * exercises.length).round();
  counter.removeWhere((bodyPart, presence) => presence < minimalTagPresence);
  if (counter.isEmpty) {
    return ['all'];
  } else {
    return counter.keys.toList();
  }
}

Future<List<String>> getWorkoutTagsViaManager(
    Workout workout, DBManager dbManager) async {
  final exercises = await dbManager
      .getJoined<Workout, Exercise>(workout.id!)
      .then((value) => value.cast<Exercise>());

      return getWorkoutTags(exercises);
}