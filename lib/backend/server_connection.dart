import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/base_model.dart';
import '../models/exercise.dart';

class ServerConnection {
  static String serverAddress = "http://192.168.1.20:8080";

  static Future<List<BaseModel>> loadFromDatabase<T extends BaseModel>() async {
    final response = await http.get(Uri.parse(serverAddress + "/exercise/all"));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      switch (T) {
        case Exercise:
          return parsed.map<T>((json) => Exercise.fromJson(json)).toList();
      }
    }

    throw Exception('Failed to load exercises from database');
  }
}
