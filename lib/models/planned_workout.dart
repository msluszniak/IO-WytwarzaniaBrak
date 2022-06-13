import 'exercise.dart';
import 'gym.dart';
import '../utils/route.dart' as Route;

class PlannedWorkout {
  final List<Gym> gymsToVisit;
  final List<List<Exercise>> exercisesOnGyms;
  final Route.Route route;

  PlannedWorkout({required this.gymsToVisit, required this.exercisesOnGyms, required this.route});

  @override
  String toString() {
    return 'PlannedWorkout{gymsToVisit: $gymsToVisit, exercisesOnGyms: $exercisesOnGyms}';
  }
}