import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/models/favorites.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  static const routeName = '/map';

  const MapPage({Key? key}) : super(key: key);

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
            markers: [
                Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(51.5, -0.09),
                builder: (ctx) => Container(
                  child: IconButton(
                    icon: Icon(Icons.circle),
                    onPressed: null,
                  ),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(51.485, -0.07),
                builder: (ctx) => Container(
                  child: FlutterLogo(),
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(51.51, -0.08),
                builder: (ctx) => Container(
                  child: FlutterLogo(),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
