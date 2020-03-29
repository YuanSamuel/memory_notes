import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
import 'package:geocoder/geocoder.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static String uname = 'ACd2fc0b0525c64d3aad7ab1e4990df8d3';
  static String pword = '53cacf2f6d17a96a1b14acb0c2f22fee';
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
  bool sent;

  List<Marker> allMarkers = new List<Marker>();

  GoogleMapController mapController;
  lo.LocationData currentPos;
  lo.Location location = new lo.Location();
  Address first;

  final LatLng center = const LatLng(45.521563, -122.677433);
  int number = 0;

  @override
  void initState() {
    sent = false;
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
          checkSendMessage();
        });
      } else {
        currentPos = currentLocation;
        checkSendMessage();
      }
    });
  }

  checkSendMessage() async {
    bool sent = false;
    print('check');
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    for (int i = 0; i < snap.data['entries'].length; i++) {
      print(snap.data['entries'][i]);
      DocumentSnapshot location = await Firestore.instance
          .collection('entries')
          .document(snap.data['entries'][i])
          .get();
      double dist = await Geolocator().distanceBetween(
          currentPos.latitude,
          currentPos.longitude,
          location.data["coords"].latitude,
          location.data["coords"].longitude);
      print(dist);
      if (dist < 25) {
        if (sent) {
          Firestore.instance
              .collection('entries')
              .document(snap.data['entries'][i])
              .updateData({"status": 1});
        }
        else if (location.data["status"] == null || location.data["status"] == 0) {
          print("SEND TEXT");
          Timer(Duration(seconds: 3), () {
            if (location.data["status"] == null || location.data["status"] == 0) {
              post(
                  "https://api.twilio.com/2010-04-01/Accounts/ACd2fc0b0525c64d3aad7ab1e4990df8d3/Messages.json",
                  headers: {
                    'Authorization': authn
                  },
                  body: {
                    "Body":
                    "You just entered a place where you recorded a memory! Open the Memory Notes app to check it out!",
                    "From": "+12512505464",
                    "To": "+13468579528"
                  });
            }
          }
          );
          Firestore.instance
              .collection('entries')
              .document(snap.data['entries'][i])
              .updateData({"status": 1});
          sent = true;
        }
      } else {
        if (location.data["status"] == 1) {
          Timer(Duration(minutes: 15), () {
            Firestore.instance
                .collection('entries')
                .document(snap.data['entries'][i])
                .updateData({"status": 0});
          });
        }
      }
    }
  }

  void _onAddMemory(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddMemoryScreen(
                  locationData: currentPos,
                  address: first,
                ))).then((value) {
      setState(() {
        createMarkers();
      });
    });
  }

  void _onViewMemory(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ViewMemoryScreen()));
  }

  void _markerPressed(String title, String locality, String url, String songtitle, String songartist) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                width: 100.0,
                height: 100.0,
                child: url == null ? SizedBox.shrink() : Image(
                  image: Image.network(url).image,
                  fit: BoxFit.cover,
                ),
                color: Colors.blue,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
              ),
              Text(
                locality,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                songtitle,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
              ),
              Text(
                songartist,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 20.0,
              ),
              Icon(
                Icons.play_arrow,
                size: 40.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                  onTap: () => _onViewMemory(context),
                  child: Text(
                    'More',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                  ))
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILDING " + currentPos.toString());
    if (currentPos == null) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _onAddMemory(context),
        ),
        body: Container(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.satellite,
              markers: allMarkers.toSet(),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(currentPos.latitude, currentPos.longitude),
                  zoom: 17.0),
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

  createMarkers() async {
    allMarkers.clear();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    for (int i = 0; i < snap.data['entries'].length; i++) {
      DocumentSnapshot location = await Firestore.instance
          .collection('entries')
          .document(snap.data['entries'][i])
          .get();
      print("Create" + i.toString());
      allMarkers.add(new Marker(
        markerId: MarkerId(((location.data["description"].hashCode +
                    location.data["coords"].latitude +
                    location.data["coords"].longitude) *
                Random().nextInt(20))
            .toString()),
        position: LatLng(location.data["coords"].latitude,
            location.data["coords"].longitude),
        onTap: () {
          _markerPressed(location.data["title"], location.data["locality"], location.data["imageUrl"], location.data['songtitle'], location.data["songartist"]);
        },
      ));
    }
    String st = "String";
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(14, 20)),
        "assets/images/currentpin3.png");
    allMarkers.add(new Marker(
      markerId: MarkerId(
          ((st.hashCode + currentPos.latitude + currentPos.longitude) *
                  Random().nextInt(20))
              .toString()),
      position: LatLng(currentPos.latitude, currentPos.longitude),
      onTap: () {
        _markerPressed("Current Location", "[${currentPos.latitude},${currentPos.longitude}]", null, "No Song", "No Artist");
      },
      icon: icon,
    ));
  }

  startPosStream() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationAlways);
    print(permission);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }
    print('change');
    lo.LocationData set = await location.getLocation();
    print(currentPos);
    currentPos = set;
    createMarkers();
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        new Coordinates(currentPos.latitude, currentPos.longitude));
    setState(() {
      first = addresses.first;
    });
  }
}
