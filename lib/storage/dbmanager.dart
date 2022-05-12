import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:flutter_demo/models/base_model.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';
import '../models/gym.dart';

class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<List<BaseModel>> getFavorites<T extends BaseModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getFavorite();
      case Gym:
        return storage.gymDAO.getFavorite();
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<List<BaseModel>> getAll<T extends BaseModel>() async {
    switch (T) {
      case Exercise:
        return storage.exerciseDAO.getAll();
      case Gym:
        return storage.gymDAO.getAll();
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
    }
    throw Exception("Invalid type provided for the database manager");
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
    }
    throw Exception("Invalid type provided for the database manager");
  }

  Future<int> updateAllData() async {
    try {
      await updateAll<Exercise>();
      await updateAll<Gym>();

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
