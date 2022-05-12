import 'package:floor/floor.dart';

abstract class BaseModel {
  @ignore
  abstract final int? id;

  BaseModel();

  BaseModel.fromJson(Map<String, dynamic> json);
}
