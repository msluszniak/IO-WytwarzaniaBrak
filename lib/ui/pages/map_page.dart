import 'dart:async';
import 'dart:convert';

import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_demo/ui/widgets/cards/gym_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as Geo;

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/route.dart' as Route;

import '../../models/planned_workout.dart';
import '../../storage/dbmanager.dart';
import '../widgets/cards/new_gym_card.dart';

enum MapMode { NOT_ESTABLISHED, NONE, SCAN, TRAINING }

class MapPage extends StatefulWidget {
  static const routeName = '/map';
  final PlannedWorkout? plannedWorkout;

  const MapPage({Key? key, this.plannedWorkout}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  List gymList = [];
  List<CircleMarker> circle = [];
  int nearby = -1;
  final double startLat = 50.0686;
  final double startLng = 19.9043;
  final double diffLat = 0.005;
  final double diffLng = -0.005;

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  MapController controller = new MapController();
  bool hasPermissions = false;
  bool inAddingMode = false;
  bool inCreatingMode = false;
  bool scanned = false;

  MapMode mode = MapMode.NOT_ESTABLISHED;

  Future<LatLng> _getPosition () async {
    Geo.Position position = await Geo.Geolocator.getCurrentPosition(
        desiredAccuracy: Geo.LocationAccuracy.high);

    print('Position found: $position');
    return LatLng(position.latitude, position.longitude);
  }

  List<LatLng> routingPointsToDraw = [];

  //Populate gym list
  @override
  void initState() {
    super.initState();

    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _checkPermission();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    this.mode = MapMode.NOT_ESTABLISHED;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var arg = ModalRoute.of(context)!.settings.arguments;
    if(this.mode == MapMode.NOT_ESTABLISHED && arg != null)
    this.mode = ModalRoute.of(context)!.settings.arguments as MapMode;

    final dbManager = context.watch<DBManager>();
    if(gymList.isEmpty) dbManager.getAll<Gym>().then((value) => gymList = value.cast());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
                mapController: this.controller,
                options: MapOptions(
                  enableMultiFingerGestureRace: true,
                  center: LatLng(0,0),
                  zoom: 12.5,
                  maxZoom: 19,
                  onMapCreated: (c) {
                    this.controller = c;
                    if (this.mode == MapMode.SCAN && !scanned) {
                      _startScan();
                    }
                    else if (this.mode == MapMode.TRAINING) {
                      _showRoute();
                    }
                  },
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
                        points: routingPointsToDraw,
                        color: Colors.blue,
                        strokeWidth: 6.0
                      ),
                    ],
                  ),
                ],
                children: <Widget>[
                  TileLayerWidget(
                    options: TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                  ),

                  if (hasPermissions)
                    LocationMarkerLayerWidget(
                      plugin: LocationMarkerPlugin(
                        centerCurrentLocationStream: _centerCurrentLocationStreamController.stream,
                        centerOnLocationUpdate: _centerOnLocationUpdate,
                      ),
                    ),

                  CircleLayerWidget(
                    options: CircleLayerOptions(
                      circles: this.circle,
                    ),
                  ),

                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: List.generate(
                        gymList.length,
                            (index) => Marker(
                          rotate: true,
                          width: 80.0,
                          height: 80.0,
                          point: gymList[index].getLatLng(),
                          builder: (ctx) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                setState(() {
                                  this.controller.move(gymList[index].getLatLng(), this.controller.zoom);
                                });
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (BuildContext context) => GymCard(
                                    selectedGym: gymList[index],
                                  ),
                                );
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
                    child: Visibility(visible: inAddingMode, child: Icon(Icons.location_on, size: 40, color: Colors.red),),
                  ),
                  Visibility(
                    visible: this.mode == MapMode.SCAN,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildGymCountButton(),
                      ),
                    ),
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
                  /*
                  Positioned(
                    right: 20,
                    bottom: 100,
                    child: _buildRouteButton(),
                  ),
                  */
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
                            dbManager.getAll<Gym>().then((value) => gymList = value.cast());
                          });
                        },
                      ),
                      visible: this.inCreatingMode,
                    ),
                  ),
                ],
              ),
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

  void _showRoute() async {
    if(routingPointsToDraw.isEmpty) {
      PlannedWorkout? workout = widget.plannedWorkout;
      if (workout != null) {
        LatLng start, finish;
        List<LatLng> middle;

        start = await _getPosition();
        finish = workout.gymsToVisit.removeLast().getLatLng();
        //middle = workout.gymsToVisit.map((element) {element.getLatLng();}).fold([], (list,e){e ?? list.add(e) : list;});
        middle = [for (Gym gym in workout.gymsToVisit) gym.getLatLng(),];
        _drawRoute(start,
          finish,
          middle,);
      }
    }
  }

  void _drawRoute(LatLng startingPoint, LatLng endingPoint, [List<LatLng> middlePoints = const []]) async {
    try {
      final route = await Route.Route.createRoute(startingPoint, endingPoint, middlePoints).timeout(Duration(seconds: 5));
      routingPointsToDraw = route.getRoutingPoints();
    } on TimeoutException catch(_) {
      Fluttertoast.showToast(msg: "Route obtaining timeout reached");
    } on Exception catch(_) {
      Fluttertoast.showToast(msg: "Error occured - route cannot be drawn");
    }
    setState(() {});
  }

  //Zostawiam dla odniesienia
  /*
  void _clearRoute() {
    routingPointsToDraw = [];
    setState(() {});
  }
   */

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
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }
    setState(() {
      hasPermissions = false;
    });
  }

  void _endScan(){
    setState(() {
      this.mode = MapMode.NONE;
      this.circle.clear();
    });
  }

  void _startScan() async {
    if(!scanned) {
      scanned = true;
      LatLng center = await _getPosition();
      int count = await _countGymsNearby();
      setState(() {
        this.nearby = count;
        this.circle.add(CircleMarker(
            point: center,
            color: Colors.blue.withOpacity(0.3),
            borderColor: Colors.blueAccent,
            borderStrokeWidth: 5,
            useRadiusInMeter: true,
            radius: 2500),);
      });
    }
  }

  Future<void> _findLocalization() async {
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
      _centerCurrentLocationStreamController.add(12.5);
    }
  }

  FloatingActionButton _buildLocalizationButton() {
    return FloatingActionButton(
      heroTag: "center",
      onPressed: _findLocalization,
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
      ),
    );
  }

  //Zostawiam dla odniesienia
  /*
  FloatingActionButton _buildRouteButton() {
    return FloatingActionButton(
      heroTag: "route",
      onPressed: () {
        if(routingPointsToDraw.isEmpty)
          _showRoute();
        else
          _clearRoute();
      },
      child: const Icon(
        Icons.alt_route,
        color: Colors.blue,
      ),
    );
  }
  */

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
            child: Text('Please turn on localization and grant this app permissions to it.'),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: openAppSettings,
              child: Text('Open settings'),
            ),
          ),
        ],),
      ),
    );
  }

  Builder _buildGymCountButton() {
    return Builder(
        builder: (BuildContext builder) {
          if(this.nearby >= 0){
            return FloatingActionButton.extended(
              heroTag: "nearby",
              label: Text('Gyms nearby: $nearby'),
              onPressed: _endScan,);
          }
          else{
            return FloatingActionButton.extended(
              heroTag: "nearby",
              label: Text('Scanning area...'),
              onPressed: () => null,);
          }
        },
    );

  }

  Future<int> _countGymsNearby() async {
    int count = 0;
    Distance distance = Distance();
    LatLng userPos = await _getPosition();
    for(Gym gym in this.gymList) {
      LatLng gymPos = gym.getLatLng();
      double dist = distance(userPos, gymPos);
      if(dist < 2500.0)
        count++;
    }
    return count;
  }
}
