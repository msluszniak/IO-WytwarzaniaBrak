import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';
import 'package:flutter_demo/models/user_workout_exercises.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/abstract/base_join_model.dart';
import '../models/abstract/base_model.dart';
import '../models/exercise.dart';
import '../models/gym.dart';
import '../models/user_workout.dart';
import '../models/workout.dart';

class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<int> submitToDatabase<T extends BaseModel>(T item) async {
    try {
      await ServerConnection.submitToDatabase<T>(item);
    } on ServerException catch (e) {
      return e.responseCode;
    }
    return 200;
  }

  Future<List<int>> addToLocal<T extends BaseModel>(
      List<BaseModel> item) async {
    switch (T) {
      case UserWorkout:
        return storage.userWorkoutDAO.add(item.cast<UserWorkout>());
      case UserWorkoutExercise:
        return storage.userWorkoutExerciseDAO
            .add(item.cast<UserWorkoutExercise>());
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<BaseModel>> getAll<T extends BaseModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getAll();
      case Gym:
        return storage.gymDAO.getAll();
      case Workout:
        return storage.workoutDAO.getAll();
      case UserWorkout:
        return storage.userWorkoutDAO.getAll();
      case WorkoutExercise:
        return storage.workoutExerciseDAO.getAll();
      case UserWorkoutExercise:
        return storage.userWorkoutExerciseDAO.getAll();
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<Workout>> getAllUserAndPredefined<T extends BaseIdModel>() async {
    switch (T) {
      case Workout:
        return storage.workoutDAO.getAllWithUsers();
    }
    throw Exception("Invalid type provided for the database manager");
  }

  /// Methods only for entities with id
  Future<List<BaseIdModel>> getFavorites<T extends BaseIdModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getFavorite();
      case Gym:
        return storage.gymDAO.getFavorite();
      case Workout:
        return storage.workoutDAO.getFavorite();
      case UserWorkout:
        return storage.userWorkoutDAO.getFavorite();
    }
    throw Exception("Invalid type provided for the database manager");
  }

  void setFavourite<T extends BaseIdModel>(int id, bool flag) async {
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

  Future<List<BaseIdModel>> getJoined<L extends BaseIdModel, R extends BaseIdModel>
      (int id, {bool userDefined = false}) {
    if (L == Workout && R == Exercise) {
      if (!userDefined)
        return storage.workoutDAO.getJoinedExercises(id);
      else
        return storage.userWorkoutDAO.getJoinedExercises(id);
    } else if (R == Workout && L == Exercise) {
      return storage.exerciseDAO.getJoinedWorkouts(id);
    }
    throw Exception("Invalid types provided for the database manager");
  }

  /// Update methods
  Future<List<BaseModel>> _loadFromDatabase<T extends BaseModel>() {
    late final Future<List<BaseModel>> items;
    try {
      items = ServerConnection.loadFromDatabase<T>();
    } on ServerException catch (e) {
      throw e;
    }
    return items;
  }

  Future<void> updateIdEntity<T extends BaseIdModel>() async {
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

  Future<void> updateJoinEntity<T extends BaseJoinModel>() async {
    late final List<BaseJoinModel> items;
    try {
      items = (await _loadFromDatabase<T>()).cast<BaseJoinModel>();
    } on ServerException catch (e) {
      throw e;
    }

    switch (T) {
      case WorkoutExercise:
        {
          List<WorkoutExercise> workoutExercises =
          items.cast<WorkoutExercise>();
          storage.workoutExerciseDAO.updateAll(workoutExercises);
          return;
        }
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<int> updateAllData() async {
    try {
      await updateIdEntity<Exercise>();
      await updateIdEntity<Gym>();
      await updateIdEntity<Workout>();

      await updateJoinEntity<WorkoutExercise>();

      return 200;
    } on ServerException catch (e) {
      return e.responseCode;
    }
  }

  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);

    dbManager.updateAllData();

    return dbManager;
  }
}