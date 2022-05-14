import 'dart:async';
import 'package:flutter_demo/storage/dao/workout_exercise_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';
import 'package:flutter_demo/storage/dao/exercise_dao.dart';
import '../models/exercise.dart';

import '../models/gym.dart';
import '../models/workout.dart';
import '../models/workout_exercises.dart';
import 'dao/gym_dao.dart';
import 'dao/workout_dao.dart';

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Exercise, Gym, Workout, WorkoutExercise])
abstract class Storage extends FloorDatabase {
  //entities
  ExerciseDao get exerciseDAO;
  GymDao get gymDAO;
  WorkoutDao get workoutDAO;

  //join entities
  WorkoutExerciseDao get workoutExerciseDAO;
}
