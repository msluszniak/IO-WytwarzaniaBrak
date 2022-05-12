import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_demo/storage/dao/exercise_dao.dart';
import '../models/exercise.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/gym.dart';
import '../models/workout.dart';
import 'dao/gym_dao.dart';
import 'dao/workout_dao.dart';

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Exercise, Gym, Workout])
abstract class Storage extends FloorDatabase {
  ExerciseDao get exerciseDAO;
  GymDao get gymDAO;
  WorkoutDao get workoutDAO;
}
