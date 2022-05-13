import 'dart:async';
import 'dart:convert';

import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_demo/ui/widgets/cards/gym_card.dart';
import 'package:provider/provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../storage/dbmanager.dart';
import '../widgets/cards/new_gym_card.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/map';

  const MapPage({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  List gymList = [];
  final double startLat = 50.0686;
  final double startLng = 19.9043;
  final double diffLat = 0.005;
  final double diffLng = -0.005;

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  final MapController controller = new MapController();
  bool hasPermissions = false;
  bool inAddingMode = false;
  bool inCreatingMode = false;

  List<LatLng> routingCords = [];

  //Populate gym list
  @override
  void initState() {
    super.initState();

    // for (int i = 0; i < 10; i++) {
    //   gymList.add(new Gym(
    //       startLat + pow(-1, i) * rand.nextDouble() * diffLat,
    //       startLng + pow(-1, i) * rand.nextDouble() * diffLng,
    //       "Gym " + i.toString(),
    //       "Description of gym " + i.toString(),
    //       "Address " + i.toString()));
    // }

    //debug
    /*
    gymList.add(new Gym(
        lat: 37.428528,
        lng: -122.087967,
        name: "Oakland gym",
        description: "Oakland gym description",
        address: "Oakland gym address"));*/

    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _checkPermission();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();
    dbManager.getAll<Gym>().then((result) => gymList = result.cast<Gym>());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
          mapController: this.controller,
          options: MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 13,
            maxZoom: 19,
            onPositionChanged: (MapPosition position, bool hasGesture) {
              if (hasGesture) {
                setState(
                  () => _centerOnLocationUpdate = CenterOnLocationUpdate.never,
                );
              }
            },
          ),
          layers: [
            MarkerLayerOptions(
              markers: [],
            ),

            TappablePolylineLayerOptions(
              polylineCulling: true,
              polylines: [
                TaggedPolyline(
                  points: routingCords,
                  color: Colors.blue,
                  strokeWidth: 3.0, // plot size
                  isDotted: true, // if true id display dotted,
                ),
              ],
            ),

          ],
          children: <Widget>[
            TileLayerWidget(
              options: TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
            ),
            
            if (hasPermissions)
              LocationMarkerLayerWidget(
                plugin: LocationMarkerPlugin(
                  centerCurrentLocationStream:
                      _centerCurrentLocationStreamController.stream,
                  centerOnLocationUpdate: _centerOnLocationUpdate,
                ),
              ),
            MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: List.generate(
                  gymList.length,
                  (index) => Marker(
                    width: 80.0,
                    height: 80.0,
                    point: gymList[index].getLatLng(),
                    builder: (ctx) => Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          setState(() {
                            this.controller.move(gymList[index].getLatLng(),
                                this.controller.zoom);
                          });
                          showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (BuildContext context) =>
                                  GymCard(selectedGym: gymList[index]));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          nonRotatedChildren: <Widget>[
            Center(
              child: Visibility(
                  visible: inAddingMode,
                  child: Icon(Icons.location_on, size: 40, color: Colors.red)),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: _buildLocalizationButton(),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: _buildAddButton(),
            ),
            Positioned(
              right: 20,
              bottom: 100,
              child: _buildRouteButton(),
            ),
            Positioned(
                left: 20,
                bottom: 100,
                child: Visibility(
                  child: _buildCancelButton(),
                  visible: this.inAddingMode,
                )),
            Container(
                child: Visibility(
              child: NewGymCard(
                mapController: this.controller,
                cancelCallback: () {
                  setState(() {
                    this.inCreatingMode = false;
                  });
                },
                submitCallback: () {
                  setState(() {
                    this.inCreatingMode = false;
                    this.inAddingMode = false;
                  });
                },
              ),
              visible: this.inCreatingMode,
            ))
          ]),
    );
  }

  Future<List<LatLng>> _getRoutePoints(LatLng startingPoint, LatLng endingPoint, List<LatLng> middlePoints) async {
    StringBuffer cords = new StringBuffer("");
    cords.write(startingPoint.longitude.toString() + "," + startingPoint.latitude.toString() + ";");
    middlePoints.forEach((element) {cords.write(element.longitude.toString() + "," + element.latitude.toString() + ";");});
    cords.write(endingPoint.longitude.toString() + "," + endingPoint.latitude.toString());

    http.Response response = await http.get(Uri.parse('http://router.project-osrm.org/route/v1/foot/' + cords.toString() + "?steps=true&geometries=geojson"));

    if(response.statusCode == 200) {
      final List cords = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];

      List<LatLng> routingPoints = [];
      
      cords.forEach((element) {
        routingPoints.add(LatLng(element[1], element[0]));
      });

      return routingPoints;
    } else
      throw Exception('Failed to calculate route');
  }

  void _drawRoute(Duration timeout, LatLng startingPoint, LatLng endingPoint, [List<LatLng> middlePoints = const []]) async {
    try {
      routingCords = await _getRoutePoints(startingPoint, endingPoint, middlePoints).timeout(timeout);
    } on TimeoutException catch(_) {
      Fluttertoast.showToast(msg: "Route obtaining timeout reached");
    } on Exception catch(_) {
      Fluttertoast.showToast(msg: "Error occured - route cannot be drawn");
    }
    setState(() {});
  }

  void _clearRoute() {
    routingCords = [];
    setState(() {});
  }

  // Also prints debug info
  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
    }
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      setState(() {
        hasPermissions = true;
      });
      return;
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }
    setState(() {
      hasPermissions = false;
    });
  }

  FloatingActionButton _buildLocalizationButton() {
    return FloatingActionButton(
      heroTag: "center",
      onPressed: () async {
        if (!hasPermissions) {
          await _checkPermission();
          if (!hasPermissions) {
            _showSnackBar();
          }
        }
        if (hasPermissions) {
          setState(
            () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
          );
          _centerCurrentLocationStreamController.add(18);
        }
      },
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
      ),
    );
  }

  FloatingActionButton _buildRouteButton() {
    return FloatingActionButton(
      onPressed: () {
        _drawRoute(Duration(seconds: 3), LatLng(50.07085, 19.92222), LatLng(50.06041, 19.95807));
      },
      child: const Icon(
        Icons.ac_unit,
        color: Colors.blue,
      ),
    );
  }

  FloatingActionButton _buildCancelButton() {
    return FloatingActionButton(
      heroTag: "cancel",
      onPressed: () {
        setState(() {
          this.inAddingMode = false;
        });
      },
      child: Icon(
        Icons.clear,
        color: Colors.red,
      ),
    );
  }

  FloatingActionButton _buildAddButton() {
    return FloatingActionButton(
      heroTag: "confirm",
      onPressed: () {
        setState(() {
          if (this.inAddingMode) {
            setState(() {
              this.inCreatingMode = true;
              this.inAddingMode = true;
            });
          } else {
            setState(() {
              this.inAddingMode = true;
            });
          }
        });
      },
      child: Icon(
        (inAddingMode) ? Icons.done : Icons.add,
        color: Colors.green,
      ),
    );
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Expanded(
            child: Text(
                'Please turn on localization and grant this app permissions to it.'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: openAppSettings,
              child: Text('Open settings'),
            ),
          )
        ]),
      ),
    );
  }
}
