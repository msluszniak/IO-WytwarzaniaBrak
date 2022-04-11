import 'dart:async';

import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_demo/ui/widgets/cards/gym_card.dart';
import 'package:flutter_demo/backend/database_connection.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

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

  Future<List<Gym>> setupMarkers() async {
    return getGymData();
  }

  //Populate gym list
  @override
  void initState() {
    super.initState();
    getGymData().then((result) => gymList = result);
    // for (int i = 0; i < 10; i++) {
    //   gymList.add(new Gym(
    //       startLat + pow(-1, i) * rand.nextDouble() * diffLat,
    //       startLng + pow(-1, i) * rand.nextDouble() * diffLng,
    //       "Gym " + i.toString(),
    //       "Description of gym " + i.toString(),
    //       "Address " + i.toString()));
    // }
    //debug
    gymList.add(new Gym(
        lat: 37.428528,
        lng: -122.087967,
        name: "Oakland gym",
        description: "Oakland gym description",
        address: "Oakland gym address"));
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

  FloatingActionButton _buildCancelButton() {
    return FloatingActionButton(
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
