import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Gym {
  double lat = 0;
  double lng = 0;
  String name = "";
  String description = "";
  String address = "";

  Gym(
      {required this.lat,
      required this.lng,
      required this.name,
      required this.description,
      String address = ""});

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  String getAddress() {
    if (address == "") return lat.toString() + ", " + lng.toString();
    return address;
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
