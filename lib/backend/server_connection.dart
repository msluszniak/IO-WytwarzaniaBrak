import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/abstract/base_model.dart';
import '../models/equipment.dart';
import '../models/exercise.dart';
import '../models/gym.dart';
import '../models/planned_workout.dart';
import '../models/workout.dart';
import '../models/workout_exercises.dart';
import '../utils/route.dart' as Route;

class ServerConnection {
  static final String configFile = "assets/config/config.json";
  static String serverAddress = "";

  static getServerAddress() async {
    if(serverAddress != "") return;

    try {
      final String response = await rootBundle.loadString(configFile);
      final data = await json.decode(response);
      serverAddress = data["serverAddress"];
    } catch(error) {
      print("Something went wrong while loading server address. Make sure that assets/config/config.json exists and contains correct IP!");
      print(error);
      throw error;
    }


    print("Server address: $serverAddress");
  }

  static String _getLoadRequestPath<T extends BaseModel>(){
    switch(T){
      case Gym : return "gym/all";
      case Workout : return "workout/all";
      case Exercise : return "exercise/all";
      case Equipment : return "equipment/all";
      case WorkoutExercise : return "workout/all_exercises";
    }
    return "";
  }

  static Future<List<BaseModel>> loadFromDatabase<T extends BaseModel>() async {
    await getServerAddress();
    String requestPath = _getLoadRequestPath<T>();

    late final response;

    try {
      response = await http
          .get(Uri.parse("http://$serverAddress/$requestPath"))
          .timeout(const Duration(seconds: 7));
    } on TimeoutException catch (_) {
      throw ServerException(responseCode: 408); // Timed out
    }

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      switch (T) {
        case Exercise:
          return parsed.map<T>((json) => Exercise.fromJson(json)).toList();
        case Equipment:
          return parsed.map<T>((json) => Equipment.fromJson(json)).toList();
        case Gym:
          return parsed.map<T>((json) => Gym.fromJson(json)).toList();
        case Workout:
          return parsed.map<T>((json) => Workout.fromJson(json)).toList();
        case WorkoutExercise:
          return parsed.map<T>((json) => WorkoutExercise.fromJson(json)).toList();
      }

      throw ServerException(responseCode: 400);
    }
    throw ServerException(responseCode: response.statusCode);
  }

  static Future<void> submitToDatabase<T extends BaseModel>(T item) async {
    await getServerAddress();
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

  static Future<PlannedWorkout> getPlannedWorkout(Future<LatLng> startPosition, List<int> exerciseIds) async {
    await getServerAddress();
    final startingPosition = await startPosition;
    late final response;

    final Map<String, Object?> params = {};
    params['exercisesIds'] = exerciseIds.toString().replaceAll("[", "").replaceAll("]", "");

    try {
      response = await http.post(Uri.http(serverAddress, "/combined/findPath", params)).timeout(const Duration(seconds: 14));
    } on TimeoutException catch (_) {
      throw ServerException(responseCode: 408); // Timed out
    }

    if(response.statusCode == 200) {
      final parsedGyms = jsonDecode(response.body)["gymsToVisit"].cast<Map<String, dynamic>>();
      List<Gym> gyms = parsedGyms.map<Gym>((json) => Gym.fromJson(json)).toList();

      List<List<Exercise>> exercises = <List<Exercise>>[];
      final allExercises = jsonDecode(response.body)["exercisesOnGyms"];
      for(int i=0; i<allExercises.length; i++) {
        final parsedExercises = allExercises[i].cast<Map<String, dynamic>>();
        exercises.add(parsedExercises.map<Exercise>((json) => Exercise.fromJson(json)).toList());
      }

      final route = await Route.Route.routeFromGyms(startingPosition, gyms);

      return PlannedWorkout(gymsToVisit: gyms, exercisesOnGyms: exercises, route: route!);
    }
    throw ServerException(responseCode: response.statusCode);
  }
}
