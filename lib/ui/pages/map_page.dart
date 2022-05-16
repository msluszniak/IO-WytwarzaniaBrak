import 'dart:async';

import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_demo/ui/widgets/cards/gym_card.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as Geo;

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../../storage/dbmanager.dart';
import '../widgets/cards/new_gym_card.dart';

enum MapMode { NOT_ESTABLISHED, NONE, SCAN }

class MapPage extends StatefulWidget {
  static const routeName = '/map';

  const MapPage({Key? key}) : super(key: key);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var arg = ModalRoute.of(context)!.settings.arguments;
    if(this.mode == MapMode.NOT_ESTABLISHED && arg != Null)
    this.mode = ModalRoute.of(context)!.settings.arguments as MapMode;
    else this.mode = MapMode.NONE;

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
                    ),
                  ),
                ],
              ),
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
            return FloatingActionButton.extended(label: Text('Gyms nearby: $nearby'), onPressed: _endScan,);
          }
          else{
            return FloatingActionButton.extended(label: Text('Scanning area...'), onPressed: () => null,);
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
