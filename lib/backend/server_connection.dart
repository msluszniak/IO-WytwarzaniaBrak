import 'dart:async';
import 'dart:convert';
import 'package:flutter_demo/backend/server_exception.dart';
import 'package:http/http.dart' as http;

import '../models/base_model.dart';
import '../models/exercise.dart';
import '../models/gym.dart';

class ServerConnection {
  static String serverAddress = "http://192.168.1.20:8080";

  static Future<List<BaseModel>> loadFromDatabase<T extends BaseModel>() async {
    late final response;

    String requestPath = T.toString().toLowerCase();

    try {
      response = await http
          .get(Uri.parse(serverAddress + "/$requestPath/all"))
          .timeout(const Duration(seconds: 5));
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
      }
    }
    throw ServerException(responseCode: response.statusCode);
  }
}
