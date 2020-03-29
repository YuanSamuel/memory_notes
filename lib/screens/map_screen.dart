import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/view_memory_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lo;
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  static String uname = 'ACd2fc0b0525c64d3aad7ab1e4990df8d3';
  static String pword = '53cacf2f6d17a96a1b14acb0c2f22fee';
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

  GoogleMapController mapController;
  lo.LocationData currentPos;
  lo.Location location = new lo.Location();

  final LatLng center = const LatLng(45.521563, -122.677433);
  int number = 0;

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
      if (mounted) {
        setState(() {
          number++;
          currentPos = currentLocation;
        });
      }
      else {
        currentPos = currentLocation;
      }
    });
  }

  checkSendMessage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap = await Firestore.instance.collection('users').document(user.uid).get();
    for (int i = 0; i < snap.data['entries'].length; i++) {
      print('hi');
      double dist = await Geolocator().distanceBetween(currentPos.latitude, currentPos.longitude, 0, 0);
      if (dist < 5){
        post("https://api.twilio.com/2010-04-01/Accounts/ACd2fc0b0525c64d3aad7ab1e4990df8d3/Messages.json", headers: {'Authorization': authn}, body: {"Body":"8:45","From":"+12512505464","To":"+12816907446"});
      }

    }
  }

  void _onAddMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>AddMemoryScreen(locationData: currentPos)));
  }

  void _onViewMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewMemoryScreen()));
  }

  void _markerPressed(){
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                width: 100.0,
                height: 100.0,
                child: Image.asset('assets/images/2.jpg', fit: BoxFit.cover,),
                color: Colors.blue,
              ),
              SizedBox(height: 10.0,),
              Text('La Centerra', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),),
              Text('Katy, Texas', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),),

              SizedBox(height: 20.0,),

              Text('I want it that way', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),),
              Text('Backstreet Boys', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),),

              SizedBox(height: 20.0,),

              Icon(Icons.play_arrow, size: 40.0,),

              SizedBox(height: 40.0,),


              GestureDetector(
                onTap: () => _onViewMemory(context),
                  child: Text('More', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),))

            ],

          )
      );
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
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: ()=> _onAddMemory(context),),
        body: Container(
            child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    mapType: MapType.satellite,
                    markers: [Marker(
                      markerId: MarkerId("Position"),
                      position: LatLng(currentPos.latitude, currentPos.longitude),
                      onTap: _markerPressed,
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
