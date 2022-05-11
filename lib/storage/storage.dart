import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_demo/storage/dao/exercise_dao.dart';
import '../models/exercise.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'storage.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Exercise])
abstract class Storage extends FloorDatabase {
  ExerciseDao get exerciseDAO;
}
