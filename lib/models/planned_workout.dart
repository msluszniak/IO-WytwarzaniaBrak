import 'exercise.dart';
import 'gym.dart';

class PlannedWorkout {
  final List<Gym> gymsToVisit;
  final List<List<Exercise>> exercisesOnGyms;

  PlannedWorkout({required this.gymsToVisit, required this.exercisesOnGyms});

  PlannedWorkout.fromJson(Map<String, dynamic> json)
      : gymsToVisit = json['gymsToVisit'],
        exercisesOnGyms = json['exercisesOnGyms'];

  @override
  String toString() {
    return 'PlannedWorkout{gymsToVisit: $gymsToVisit, exercisesOnGyms: $exercisesOnGyms}';
  }
}