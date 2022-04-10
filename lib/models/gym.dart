import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../utils/geolocator.dart';

class Gym {
  double lat = 0;
  double lng = 0;
  String name = "";
  String description = "";
  String address = "";

  Gym(double lat, double lng, String name, String description, String address) {
    this.lat = lat;
    this.lng = lng;
    this.name = name;
    this.description = description;
    this.address = address;
  }

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  String getAddress() {
    return address;
  }

  LatLng getLatLng() {
    return new LatLng(this.lat, this.lng);
  }

  Future<http.Response> _getJsonWithDistance(String lat1, String lng1, String lat2, String lng2) {
    return http.get(Uri.parse('http://router.project-osrm.org/route/v1/foot/' + lng1 + ',' + lat1 + ';' + lng2 + ',' + lat2));
  }

  Future<double> getDistance() async {
    Position pos = await GeolocatorUtil.determinePosition();
    http.Response response = await _getJsonWithDistance(pos.latitude.toString(), pos.longitude.toString(),
        lat.toString(), lng.toString());

    if (response.statusCode == 200) {
      final v = jsonDecode(response.body)['routes'][0]['distance'];
      if(v.runtimeType == double)
        return v;
      else if(v.runtimeType == int)
        return v.toDouble();
      else
        throw Exception('Failed to calculate distance');
    } else
      throw Exception('Failed to calculate distance');
  }
}