import 'dart:async';
import 'package:flutter_demo/models/user_workout.dart';
import 'package:flutter_demo/models/user_workout_exercises.dart';
import 'package:flutter_demo/storage/dao/workout_exercise_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';
import 'package:flutter_demo/storage/dao/exercise_dao.dart';
import '../models/exercise.dart';

import '../models/gym.dart';

import '../models/equipment.dart';
import 'dao/equipment_dao.dart';
import '../models/workout.dart';
import '../models/workout_exercises.dart';

import 'dao/gym_dao.dart';
import 'dao/user_workout_dao.dart';
import 'dao/user_workout_exercise_dao.dart';
import 'dao/workout_dao.dart';

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Exercise, Gym, Workout, WorkoutExercise, UserWorkout, UserWorkoutExercise])
abstract class Storage extends FloorDatabase {
  //entities
  ExerciseDao get exerciseDAO;
  GymDao get gymDAO;
  EquipmentDao get equipmentDAO;
  WorkoutDao get workoutDAO;
  UserWorkoutDao get userWorkoutDAO;

  //join entities
  WorkoutExerciseDao get workoutExerciseDAO;
  UserWorkoutExerciseDao get userWorkoutExerciseDAO;
}
