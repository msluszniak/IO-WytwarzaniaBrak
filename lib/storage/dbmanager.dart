import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:flutter_demo/models/abstract/base_id_model.dart';
import 'package:flutter_demo/models/workout_exercises.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/abstract/base_model.dart';
import '../models/exercise.dart';
import '../models/gym.dart';

import '../models/equipment.dart';
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

  Future<List<int>> addToLocal<T extends BaseModel>(List<T> item) async {
    switch (T) {
      case Workout:
        final workouts = item
            .cast<Workout>()
            .map((e) => new Workout(
                name: e.name,
                isFavorite: e.isFavorite,
                userDefined: e.userDefined))
            .toList();
        return storage.workoutDAO.addAll(workouts);
      case WorkoutExercise:
        {
          final allExercises =
              (await storage.exerciseDAO.getAll()).map((e) => e.id!);

          List<WorkoutExercise> exercises = item.cast<WorkoutExercise>();
          exercises.removeWhere((e) => !allExercises.contains(e.exerciseId));

          return storage.workoutExerciseDAO.addAll(exercises);
        }
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
      case WorkoutExercise:
        return storage.workoutExerciseDAO
            .getAll()
            .then((values) => values.cast<T>());
    }
    throw Exception("Invalid type provided for the database manager");
  }

  /// Methods only for entities with id
  Future<List<T>> getFavorites<T extends BaseIdModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO
            .getFavorite()
            .then((values) => values.cast<T>());
      case Gym:
        return storage.gymDAO.getFavorite().then((values) => values.cast<T>());
      case Workout:
        return storage.workoutDAO
            .getFavorite()
            .then((values) => values.cast<T>());
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
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<R>> getJoined<L extends BaseModel, R extends BaseModel>(int id) {
    if (L == Workout && R == Exercise) {
      return storage.workoutDAO
          .getJoinedExercises(id)
          .then((values) => values.cast<R>());
    } else if (R == Workout && L == Exercise) {
      return storage.exerciseDAO
          .getJoinedWorkouts(id)
          .then((values) => values.cast<R>());
    } else if (L == Exercise && R == Equipment) {
      return storage.exerciseDAO
          .getJoinedEquipments(id)
          .then((values) => values.cast<R>());
    } else if (R == Exercise && L == Equipment) {
      return storage.equipmentDAO
          .getJoinedExercises(id)
          .then((values) => values.cast<R>());
    } else if (L == Workout && R == WorkoutExercise) {
      return storage.workoutExerciseDAO
          .getAllWithWorkout(id)
          .then((values) => values.cast<R>());
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

  Future<void> _updateEntityWithFavorite<T extends BaseIdModel>() async {
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
          storage.exerciseDAO.updateFromDatabase(exercises);
          storage.exerciseDAO.updateFavorites(favoriteIds);
          return;
        }
      case Gym:
        {
          List<Gym> gyms = items.cast<Gym>();
          storage.gymDAO.updateFromDatabase(gyms);
          storage.gymDAO.updateFavorites(favoriteIds);
          return;
        }
      case Workout:
        {
          List<Workout> workouts = items.cast<Workout>();
          storage.workoutDAO.updateFromDatabase(workouts);
          storage.workoutDAO.updateFavorites(favoriteIds);
          return;
        }
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<void> _updateEntityWithoutFavorite<T extends BaseModel>() async {
    late final List<BaseModel> items;
    try {
      items = (await _loadFromDatabase<T>()).cast<BaseModel>();
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
      case Equipment:
        {
          List<Equipment> equipments = items.cast<Equipment>();
          storage.equipmentDAO.updateFromDatabase(equipments);
          return;
        }
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<int> updateAllData() async {
    //Save local workouts
    List<Workout> localWorkouts = await storage.workoutDAO.getLocal();
    Map<int, List<WorkoutExercise>> localExercises = {};
    for (Workout workout in localWorkouts) {
      localExercises[workout.id!] =
          await storage.workoutExerciseDAO.getAllWithWorkout(workout.id!);
    }

    storage.workoutExerciseDAO.removeLocal();
    storage.workoutDAO.removeLocal();

    try {
      await _updateEntityWithFavorite<Exercise>();
      await _updateEntityWithFavorite<Gym>();
      await _updateEntityWithFavorite<Workout>();

      await _updateEntityWithoutFavorite<WorkoutExercise>();
      await _updateEntityWithoutFavorite<Equipment>();

      //Restore local workouts
      final exerciseIds =
          await storage.exerciseDAO.getAll().then((v) => v.map((e) => e.id));

      final newIds = await this.addToLocal<Workout>(localWorkouts);
      for (int i = 0; i < localWorkouts.length; i++) {
        final workout = localWorkouts[i];
        final workoutExercises = localExercises[workout.id]!
            .map((e) => new WorkoutExercise(
                workoutId: newIds[i],
                exerciseId: e.exerciseId,
                series: e.series,
                reps: e.reps))
            .toList();

        workoutExercises
            .removeWhere((e) => !exerciseIds.contains(e.exerciseId));

        this.addToLocal<WorkoutExercise>(workoutExercises);
      }

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
