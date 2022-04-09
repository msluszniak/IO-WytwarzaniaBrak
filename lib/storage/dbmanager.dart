import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/storage/storage.dart';

import '../models/exercise.dart';


// This is the class used by rest of your codebase

// The store-class
class DBManager extends ChangeNotifier {
  final Storage storage;
  DBManager(this.storage);

  Future<List<Exercise>> getFavExercises() async => await storage.exerciseDAO.getFavExercises();

  void addExercise(String name) async {
    await storage.exerciseDAO.addExercise(Exercise(name: name));
    notifyListeners();
  }


  Future<List<Exercise>> getExercises() async => await storage.exerciseDAO.getExercises();

  void setFavourite(int id, bool flag) async {
    await storage.exerciseDAO.setFavourite(id, flag);
    notifyListeners();
  }


  // manager.getStorage().
}