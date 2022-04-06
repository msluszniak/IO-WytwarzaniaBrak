import 'package:latlong2/latlong.dart';

class Gym {
  double lat = 0;
  double lng = 0;
  String name = "";
  String description = "";

  Gym(double lat, double lng, String name, String description) {
    this.lat = lat;
    this.lng = lng;
    this.name = name;
    this.description = description;
  }

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  LatLng getLatLng() {
    return new LatLng(this.lat, this.lng);
  }
}