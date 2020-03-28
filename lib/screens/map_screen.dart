import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lo;


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController mapController;
  lo.LocationData currentPos;
  lo.Location location = new lo.Location();

  final LatLng center = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    print('init');
    startPosStream();
    listenLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> listenLocation() async {
    location.onLocationChanged.listen((lo.LocationData currentLocation) {
      print('changed');
      setState(() {
        currentPos = currentLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(currentPos);
    if (currentPos == null) {
      return Scaffold(
        body: Center(child: Text("Loading..."),),
      );
    }
    else {
      return Scaffold(
        body: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    markers: [Marker(
                      markerId: MarkerId("Position"),
                      position: LatLng(currentPos.latitude, currentPos.longitude),
                    )].toSet(),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentPos.latitude, currentPos.longitude),
                        zoom: 15.0
                    ),
                  ),
                ),
//                Container(
//                  alignment: Alignment.topCenter,
//                  child: Column(
//                    children: <Widget>[
//                      SizedBox(height: MediaQuery.of(context).size.height / 20,
//                      child: DecoratedBox(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                        ),
//                      ),),
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: PlacesAutocompleteField(controller: searchController,
//                          apiKey: GoogleAPIKey,
//                          inputDecoration: InputDecoration(
//                            border: OutlineInputBorder(
//                              borderSide: BorderSide(
//                                  color: Colors.blue
//                              ),
//                              borderRadius: BorderRadius.circular(10.0),
//                            ),
//                            filled: true,
//                            fillColor: Colors.white,
//                          ),
//                        ),
//                      ),
//                    ],
//                  )
//                ),
              ],
            )
        ),
      );
    }
  }
  startPosStream() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
    print(permission);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.locationAlways]);
    }
    print('change');
    lo.LocationData set = await location.getLocation();
    setState(() {
      currentPos = set;
    });
    print(currentPos);

  }
}
