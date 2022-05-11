import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/backend/server_connection.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';

class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<List<Exercise>> getFavExercises() async =>
      await storage.exerciseDAO.getFavExercises();

  Future<List<Exercise>> getExercises() async =>
      await storage.exerciseDAO.getExercises();

  void setFavourite(int id, bool flag) async {
    await storage.exerciseDAO.setFavourite(id, flag);
    notifyListeners();
  }

  void updateExercises() async {
    List<int> favoriteIds = await getFavExercises()
        .then((exercises) => exercises.map((e) => e.id!).toList());

    List<Exercise> exercises = await ServerConnection.loadExercises();

    print(favoriteIds);

    storage.exerciseDAO.updateExercises(exercises);
    storage.exerciseDAO.updateExerciseFavorites(favoriteIds);
  }

  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);

    dbManager.updateExercises();

    return dbManager;
  }

  static Future<DBManager> loadTestDatabase() async {
    final dbManager = await loadDatabase();
    return dbManager;
  }
}
