import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';
import 'package:flutter_demo/models/user_workout_exercises.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/abstract/base_model.dart';
import '../models/exercise.dart';
import '../models/gym.dart';

import '../models/equipment.dart';
import '../models/user_workout.dart';
import '../models/workout.dart';


class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<List<int>> addToLocal<T extends BaseModel>(List<BaseModel> item) async {
    switch (T) {
      case UserWorkout:
        return storage.userWorkoutDAO.add(item.cast<UserWorkout>());
      case UserWorkoutExercise:
        return storage.userWorkoutExerciseDAO.add(item.cast<UserWorkoutExercise>());
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<T>> getAll<T extends BaseModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getAll().then((values) => values.cast<T>());
      case Gym:
        return storage.gymDAO.getAll().then((values) => values.cast<T>());
      case Equipment:
        return storage.equipmentDAO.getAll().then((values) => values.cast<T>());
      case Workout:
        return storage.workoutDAO.getAll().then((values) => values.cast<T>());
      case UserWorkout:
        return storage.userWorkoutDAO.getAll().then((values) => values.cast<T>());
      case WorkoutExercise:
        return storage.workoutExerciseDAO.getAll().then((values) => values.cast<T>());
      case UserWorkoutExercise:
        return storage.userWorkoutExerciseDAO.getAll().then((values) => values.cast<T>());
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<Workout>> getAllUserAndPredefined() async {
    List<Workout> predefinedWorkouts = await storage.workoutDAO.getAll();
    List<UserWorkout> userWorkouts = await storage.userWorkoutDAO.getAll();
    userWorkouts.forEach((element) {print("ID: " + element.id.toString());});
    predefinedWorkouts.addAll(userWorkouts.map((e) => Workout(id: e.id, name: e.name, isFavorite: e.isFavorite)).toList());
    return predefinedWorkouts;
  }

  /// Methods only for entities with id
  Future<List<T>> getFavorites<T extends BaseIdModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getFavorite().then((values) => values.cast<T>());
      case Gym:
        return storage.gymDAO.getFavorite().then((values) => values.cast<T>());
      case Workout:
        return storage.workoutDAO.getFavorite().then((values) => values.cast<T>());
      case UserWorkout:
        return storage.userWorkoutDAO.getFavorite().then((values) => values.cast<T>());
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<void> setFavourite<T extends BaseIdModel>(int id, bool flag) async {
    switch (T) {
      case Exercise:
        await storage.exerciseDAO.addFavorite(id, flag);
        notifyListeners();
        return;
      case Gym:
        await storage.gymDAO.addFavorite(id, flag);
        notifyListeners();
        return;
      case Workout:
        await storage.workoutDAO.addFavorite(id, flag);
        notifyListeners();
        return;
      case UserWorkout:
        await storage.userWorkoutDAO.addFavorite(id, flag);
        notifyListeners();
        return;
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<R>> getJoined<L extends BaseIdModel, R extends BaseIdModel>(int id){
    if (L == Workout && R == Exercise){
      return storage.workoutDAO.getJoinedExercises(id).then((values) => values.cast<R>());
    }
    else if (R == Workout && L == Exercise){
      return storage.exerciseDAO.getJoinedWorkouts(id).then((values) => values.cast<R>());
    }
    else if (L == Exercise && R == Equipment){
      return storage.exerciseDAO.getJoinedEquipments(id).then((values) => values.cast<R>());
    }
    else if (R == Exercise && L == Equipment){
      return storage.equipmentDAO.getJoinedExercises(id).then((values) => values.cast<R>());
    }
    throw Exception("Invalid types provided for the database manager");
  }


  /// Update methods from database
  Future<List<T>> _loadFromDatabase<T extends BaseModel>() {
    late final Future<List<BaseModel>> items;
    try {
      items = ServerConnection.loadFromDatabase<T>();
    } on ServerException catch (e) {
      throw e;
    }
    return items.then((values) => values.cast<T>());
  }

  Future<void> updateEntityWithFavorite<T extends BaseIdModel>() async {
    late final List<BaseIdModel> items;
    try {
      items = (await _loadFromDatabase<T>()).cast<BaseIdModel>();
    } on ServerException catch (e) {
      throw e;
    }

    List<int> favoriteIds = await getFavorites<T>()
        .then((items) => items.map((e) => e.id!).toList());

    switch (T) {
      case Exercise:
        {
          List<Exercise> exercises = items.cast<Exercise>();
          storage.exerciseDAO.updateAll(exercises);
          storage.exerciseDAO.updateFavorites(favoriteIds);
          return;
        }
      case Gym:
        {
          List<Gym> gyms = items.cast<Gym>();
          storage.gymDAO.updateAll(gyms);
          storage.gymDAO.updateFavorites(favoriteIds);
          return;
        }
      case Workout:
        {
          List<Workout> workouts = items.cast<Workout>();
          storage.workoutDAO.updateAll(workouts);
          storage.workoutDAO.updateFavorites(favoriteIds);
          return;
        }
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<void> updateEntityWithoutFavorite<T extends BaseModel>() async {
    late final List<BaseModel> items;
    try {
      items = (await _loadFromDatabase<T>()).cast<BaseModel>();
    } on ServerException catch (e) {
      throw e;
    }

    switch (T) {
      case WorkoutExercise:
        {
          List<WorkoutExercise> workoutExercises = items.cast<WorkoutExercise>();
          storage.workoutExerciseDAO.updateAll(workoutExercises);
          return;
        }
      case Equipment:
        {
          List<Equipment> equipments = items.cast<Equipment>();
          storage.equipmentDAO.updateAll(equipments);
          return;
        }
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<int> updateAllData() async {
    try {
      await updateEntityWithFavorite<Exercise>();
      await updateEntityWithFavorite<Gym>();
      await updateEntityWithFavorite<Workout>();

      await updateEntityWithoutFavorite<WorkoutExercise>();
      await updateEntityWithoutFavorite<Equipment>();

      return 200;
    } on ServerException catch (e) {
      return e.responseCode;
    }
  }

  /// Add data to database
  Future<int> submitToDatabase<T extends BaseModel>(T item) async {
    try {
      await ServerConnection.submitToDatabase<T>(item);
    } on ServerException catch (e) {
      return e.responseCode;
    }
    return 200;
  }


  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);

    dbManager.updateAllData();

    return dbManager;
  }
}
