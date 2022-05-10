import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latlong2/latlong.dart';

void main() {
  test('Find place with normal address', () async {
    LatLng wiet = new LatLng(50.06808, 19.91247);
    String address = await Gym.getAddressFromLatLng(wiet);
    expect(address, "Kawiory 21");
  });

  test('Find with non-existent numeration', () async {
    LatLng jordan = new LatLng(50.0633, 19.9148);
    String address = await Gym.getAddressFromLatLng(jordan);
    expect(address, "Henryka Reymana , brak numeru");
  });

  test('Non existent address', () async {
    LatLng pacific = new LatLng(6.27763, -136.19751);
    String address = await Gym.getAddressFromLatLng(pacific);
    expect(address, "Adres nieznany");
  });
}
