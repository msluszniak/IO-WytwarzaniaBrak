import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


import '../utils/geolocator.dart';
import 'abstract/base_id_model.dart';

@entity
class Gym extends BaseIdModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final double lat;
  final double lng;
  final String name;
  final String? description;
  final String? address;
  final bool isFavorite;

  Gym(
      {this.id,
      required this.lat,
      required this.lng,
      required this.name,
      this.description,
      this.address,
      this.isFavorite = false});

  Gym.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lat = json['latitude'],
        lng = json['longitude'],
        description = json['description'],
        address = json['address'],
        isFavorite = false;

  String getAddress() {
    if (address == null)
      return lat.toString() + ", " + lng.toString();
    return address!;
  }

  Future<http.Response> _getJsonWithDistance(
      String lat1, String lng1, String lat2, String lng2) {
    return http.get(Uri.parse('http://router.project-osrm.org/route/v1/foot/' +
        lng1 +
        ',' +
        lat1 +
        ';' +
        lng2 +
        ',' +
        lat2));
  }

  Future<double> getDistance() async {
    Position pos = await GeolocatorUtil.determinePosition();
    http.Response response = await _getJsonWithDistance(pos.latitude.toString(),
        pos.longitude.toString(), lat.toString(), lng.toString());

    if (response.statusCode == 200) {
      final v = jsonDecode(response.body)['routes'][0]['distance'];
      if (v.runtimeType == double)
        return v;
      else if (v.runtimeType == int)
        return v.toDouble();
      else
        throw Exception('Failed to calculate distance');
    } else
      throw Exception('Failed to calculate distance');
  }

  LatLng getLatLng() {
    return new LatLng(this.lat, this.lng);
  }

  static Future<String> getAddressFromLatLng(LatLng latLang) async {
    var params = new Map<String, String>();
    params['lat'] = latLang.latitude.toString();
    params['lon'] = latLang.longitude.toString();
    params['format'] = 'json';

    late final response;
    try {
      response = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/reverse', params),
      );
    } catch (e) {
      print(e.toString());
      return "";
    }

    final json = jsonDecode(response.body);

    if (json['address'] == null) return 'Adres nieznany';

    final street = json['address']['road'];
    final houseNumber = json['address']['house_number'];

    var returnString = "";
    returnString += '${street != null ? street + " " : ""}';
    returnString += '${houseNumber != null ? houseNumber : ", brak numeru"}';

    if (returnString.isEmpty) return 'Adres nieznany';
    return returnString;
  }
}
