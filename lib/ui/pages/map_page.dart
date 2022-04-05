import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/map';

  const MapPage({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _Location {
  double lat = 0;
  double lng = 0;

  _Location(double lat, double lng){
    this.lat = lat;
    this.lng = lng;
  }

  LatLng getLatLng(){
    return new LatLng(this.lat, this.lng);
  }
}

class _MapState extends State<MapPage> {

  List locationsList = [];
  final double startLat = 51.5;
  final double startLng = -0.08;
  final double diffLat = 0.005;
  final double diffLng = -0.005;

  //Populate gym list
  @override
  void initState() {
    super.initState();
    Random rand = new Random();
    for(int i = 0; i < 10; i++)
      {
        locationsList.add(new _Location(startLat + pow(-1, i)*rand.nextDouble()*diffLat,
            startLng + pow(-1, i)*rand.nextDouble()*diffLng));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5, -0.09),
          zoom: 13.0,
        ),
        layers: [
          MarkerLayerOptions(
            markers: [
            ],
          ),
        ],
        children: <Widget>[
          TileLayerWidget(
              options: TileLayerOptions(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'])),
          MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: List.generate(locationsList.length, (index) => Marker(
                  width: 80.0,
                  height: 80.0,
                  point: locationsList[index].getLatLng(),
                  builder: (ctx) => Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: null,
                    ),
                  ),
                )),
              )),
        ],
      ),
    );
  }
}
