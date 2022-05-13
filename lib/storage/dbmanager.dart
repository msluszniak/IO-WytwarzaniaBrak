import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:flutter_demo/models/base_model.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';
import '../models/gym.dart';
import '../models/workout.dart';

class DBManager extends ChangeNotifier {
  final Storage storage;
  DBManager(this.storage);

  Future<int> addToDatabase<T extends BaseModel>(T item) async{
    try {
      await ServerConnection.submitToDatabase<T>(item);
    } on ServerException catch (e) {
      return e.responseCode;
    }
    return 200;
  }

  Future<List<BaseModel>> getFavorites<T extends BaseModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getFavorite();
      case Gym:
        return storage.gymDAO.getFavorite();
      case Workout:
        return storage.workoutDAO.getFavorite();
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
    }
    throw Exception("Invalid type provided for the database manager");
  }

  void setFavourite<T extends BaseModel>(int id, bool flag) async {
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
    }
  }

  Future<void> updateAll<T extends BaseModel>() async {
    List<int> favoriteIds = await getFavorites<T>()
        .then((items) => items.map((e) => e.id!).toList());

    late final List<BaseModel> items;
    try {
      items = await ServerConnection.loadFromDatabase<T>();
    } on ServerException catch (e) {
      throw e;
    }

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

          late final List<WorkoutExercise> workoutExercises;
          try {
            workoutExercises = await ServerConnection.loadWorkoutExercises();
          } on ServerException catch (e) {
            throw e;
          }

          storage.workoutDAO.updateAllExercises(workoutExercises);

          return;
        }
    }
  }

  Future<int> updateAllData() async {
    try {
      await updateAll<Exercise>();
      await updateAll<Gym>();
      await updateAll<Workout>();

      return 200;
    } on ServerException catch (e) {
      return e.responseCode;
    }
  }

  Future<List<Exercise>> getWorkoutExercises(int workoutId){
    return storage.workoutDAO.getWorkoutExercises(workoutId);
  }

  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);

    dbManager.updateAllData();

    return dbManager;
  }
}
