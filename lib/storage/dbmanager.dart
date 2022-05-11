import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/models/base_model.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';

class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<List<BaseModel>> getFavorites<T extends BaseModel>() async {
    switch(T){
      case Exercise: return storage.exerciseDAO.getFavorite();
    }
    throw Exception("Invalid type provided for the database manager");
  }


  Future<List<BaseModel>> getAll<T extends BaseModel>() async {
    switch(T){
      case Exercise: {
        return storage.exerciseDAO.getAll();
      }
    }
    throw Exception("Invalid type provided for the database manager");
  }


  void setFavourite(int id, bool flag) async {
    await storage.exerciseDAO.addFavorite(id, flag);
    notifyListeners();
  }

  void updateAll<T extends BaseModel>() async {
    List<int> favoriteIds = await getFavorites<T>()
        .then((items) => items.map((e) => e.id!).toList());

    List<BaseModel> items = await ServerConnection.loadFromDatabase<Exercise>();

    switch(T){
      case Exercise: {
        List<Exercise> exercises = items.cast<Exercise>();
        storage.exerciseDAO.updateAll(exercises);
        storage.exerciseDAO.updateFavorites(favoriteIds);
        return;
      }

    }
    throw Exception("Invalid type provided for the database manager");
  }

  void updateAllData() async {
    updateAll<Exercise>();
  }

  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);

    dbManager.updateAllData();

    return dbManager;
  }
}
