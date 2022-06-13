import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../models/gym.dart';

class Route {
  static final _HUMAN_SPEED = 1.42; // m / s

  final List<RouteStep> routeSteps = [];

  static Future<Route?> routeFromGyms(LatLng startingPoint, List<Gym> gyms) async {
    if (gyms.isEmpty)
      return null;

    final endingPoint = LatLng(gyms.last.lat, gyms.last.lng);
    List<LatLng> middlePoints = gyms.getRange(0, gyms.length - 1).map((e) => LatLng(e.lat, e.lng)).toList();

    return createRoute(startingPoint, endingPoint, middlePoints);
  }

  static Future<Route> createRoute(LatLng startingPoint, LatLng endingPoint, List<LatLng> middlePoints) async {
    Route newRoute = Route();

    StringBuffer cords = new StringBuffer("");
    cords.write(startingPoint.longitude.toString() + "," + startingPoint.latitude.toString() + ";");
    middlePoints.forEach((element) {
      cords.write(element.longitude.toString() + "," + element.latitude.toString() + ";");
    });
    cords.write(endingPoint.longitude.toString() + "," + endingPoint.latitude.toString());

    http.Response response = await http.get(Uri.parse(
        'http://router.project-osrm.org/route/v1/foot/' + cords.toString() + "?steps=true&geometries=geojson"));

    if (response.statusCode == 200) {
      final List legs = jsonDecode(response.body)['routes'][0]['legs'];

      final List<LatLng> points = [];
      for (dynamic leg in legs) {
        final steps = leg['steps'];

        for (dynamic step in steps) {
          dynamic cords = step['geometry']['coordinates'];

          cords.forEach((element) {
            points.add(LatLng(element[1], element[0]));
          });
        }
        final distance = (leg['distance'] / 10).ceil() * 10;
        final duration = (leg['distance'] / _HUMAN_SPEED / 60).ceil();

        newRoute.routeSteps.add(
            RouteStep(points: points, duration: duration, distance: distance)
        );
      }

    } else
      throw Exception('Failed to calculate route');

    return newRoute;
  }

  List<LatLng> getRoutingPoints() {
    List<LatLng> points = [];
    for (RouteStep step in routeSteps){
      print(step.distance.toString() + " " + step.duration.toString());
      points.addAll(step.points);
    }
    return points;
  }
}

class RouteStep {
  final List<LatLng> points;
  final int duration;
  final int distance;

  RouteStep({required this.points, required this.duration, required this.distance});
}
