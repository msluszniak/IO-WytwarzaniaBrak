import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';

// This is the class used by rest of your codebase

// The store-class
class DBManager extends ChangeNotifier {
  final Storage storage;

  DBManager(this.storage);

  Future<List<Exercise>> getFavExercises() async =>
      await storage.exerciseDAO.getFavExercises();

  Future<Exercise> addExercise(String name) async {
    final exercise = Exercise(name: name);
    await storage.exerciseDAO.addExercise(exercise);
    notifyListeners();
    return exercise;
  }

  Future<List<Exercise>> getExercises() async =>
      await storage.exerciseDAO.getExercises();

  void setFavourite(int id, bool flag) async {
    await storage.exerciseDAO.setFavourite(id, flag);
    notifyListeners();
  }

  static Future<DBManager> loadDatabase() async {
    final storage = await $FloorStorage.databaseBuilder('storage.db').build();
    final dbManager = DBManager(storage);
    return dbManager;
  }

  static Future<DBManager> loadTestDatabase() async {
    final dbManager = await loadDatabase();
    final exercises = await dbManager.getExercises();

    if (exercises.isEmpty) {
      dbManager.generateTestData();
    }
    return dbManager;
  }

  void generateTestData() async {
    final ids = List<int>.generate(10, (i) => i);
    final exercises = ids.map((i) => addExercise("Exercise no.$i")
        .then((exercise) => setFavourite(exercise.id!, i % 3 == 0)));
    await Future.wait(exercises);
  }
}
// manager.getStorage().
