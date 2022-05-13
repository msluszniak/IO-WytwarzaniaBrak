import 'dart:async';
import 'dart:convert';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:http/http.dart' as http;

import '../models/base_model.dart';
import '../models/exercise.dart';
import '../models/gym.dart';
import '../models/workout.dart';
import '../models/workout_exercises.dart';

class ServerConnection {
  static String serverAddress = "192.168.1.20:8080";

  static Future<List<BaseModel>> loadFromDatabase<T extends BaseModel>() async {
    late final response;

    String requestPath = T.toString().toLowerCase();

    try {
      response = await http
          .get(Uri.parse("http://$serverAddress/$requestPath/all"))
          .timeout(const Duration(seconds: 7));
    } on TimeoutException catch (_) {
      throw ServerException(responseCode: 408); // Timed out
    }

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      switch (T) {
        case Exercise:
          return parsed.map<T>((json) => Exercise.fromJson(json)).toList();
        case Gym:
          return parsed.map<T>((json) => Gym.fromJson(json)).toList();
        case Workout:
          return parsed.map<T>((json) => Workout.fromJson(json)).toList();
      }
    }
    throw ServerException(responseCode: response.statusCode);
  }

  static Future<List<WorkoutExercise>> loadWorkoutExercises() async {
    late final response;

    String requestPath = "http://$serverAddress/workout/all_exercises";

    try {
      response = await http
          .get(Uri.parse(requestPath))
          .timeout(const Duration(seconds: 7));
    } on TimeoutException catch (_) {
      throw ServerException(responseCode: 408); // Timed out
    }

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<WorkoutExercise>((json) => WorkoutExercise.fromJson(json))
          .toList();
    }

    throw ServerException(responseCode: response.statusCode);
  }

  static Future<void> submitToDatabase<T extends BaseModel>(T item) async {
    late final response;

    final Map<String, Object?> params = {};
    switch (T) {
      case Gym:
        {
          final newGym = item as Gym;

          params['name'] = newGym.name;
          params['latitude'] = newGym.lat.toString();
          params['longitude'] = newGym.lng.toString();
          params['description'] = newGym.description;
          params['address'] = newGym.address;
        }
    }

    String requestPath = T.toString().toLowerCase();
    try {
      response = await http
          .post(Uri.http(serverAddress, "$requestPath/add", params))
          .timeout(const Duration(seconds: 7));
    } on TimeoutException catch (_) {
      throw ServerException(responseCode: 408); // Timed out
    }

    if (response.statusCode == 200) return;

    throw ServerException(responseCode: response.statusCode);
  }
}
