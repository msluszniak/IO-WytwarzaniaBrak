import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/exercise.dart';

class ServerConnection {
  static String serverAddress = "http://192.168.1.20:8080";

  static Future<List<Exercise>> loadExercises() async {
    final response = await http.get(
        Uri.parse(serverAddress + "/exercise/all")
    );

    if (response.statusCode == 200){
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<Exercise>((json) => Exercise.fromJson(json)).toList();
    }

    throw Exception('Failed to load exercises from database');
  }
}