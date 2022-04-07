import 'package:latlong2/latlong.dart';

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
}