import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:background_location/background_location.dart' as bl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/view_memory_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static String uname;
  static String pword;
  static String sendNum;
  var authn;
  bool sent;

  List<Marker> allMarkers = new List<Marker>();

  Completer<GoogleMapController> mapController;
  bl.Location currentPos;
  bl.Location location = new bl.Location();
  Address first;
  String phoneNumber;

  final LatLng center = const LatLng(45.521563, -122.677433);
  int number = 0;

  @override
  void initState() {
    sent = false;
    listenLocation();
    super.initState();
  }

  Future<String> loadAsset() async {
    String s =
        await DefaultAssetBundle.of(context).loadString("assets/keys.json");
    var keys = json.decode(s);
    uname = keys["twilioSID"];
    pword = keys["twilioAuth"];
    sendNum = keys["phoneNum"];
    authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  Future<void> listenLocation() async {
    loadAsset();

    await Permission.locationAlways.request();
    bl.BackgroundLocation.getLocationUpdates((bl.Location currentLocation) async {
      currentPos = currentLocation;
      print('Changed: ' + currentLocation.latitude.toString() + ', ' + currentLocation.longitude.toString());
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          new Coordinates(currentPos.latitude, currentPos.longitude));
      if (mounted) {
        setState(() {
          number++;
          currentPos = currentLocation;
          first = addresses.first;
          checkSendMessage();
        });
      } else {
        currentPos = currentLocation;
        first = addresses.first;
        checkSendMessage();
      }
    });
  }

  checkSendMessage() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    //print(user.uid);
    for (int i = 0; i < snap.data()['entries'].length; i++) {
      DocumentSnapshot location = await FirebaseFirestore.instance
          .collection('entries')
          .doc(snap.data()['entries'][i])
          .get();
      //print("SEE LOCATION " + location.id);
      //print("SEE LOCATION " + location.data().toString());
      double dist = Geolocator.distanceBetween(
          currentPos.latitude,
          currentPos.longitude,
          location.data()["coords"].latitude,
          location.data()["coords"].longitude);
      //print('SENT:' + sent.toString());
      print(location.data()["status"]);
      print('Distance: ' + dist.toString());
      if (dist < 50) {
        print('hello?');
        if (sent) {
          print("ALREADY SENT");
          FirebaseFirestore.instance
              .collection('entries')
              .doc(snap.data()['entries'][i])
              .update({"status": 1});
        } else if (location.data()["status"] == 0 ||
            location.data()["status"] == null) {
          print("HERE");
          post(
              "https://api.twilio.com/2010-04-01/Accounts/" +
                  uname +
                  "/Messages.json",
              headers: {
                'Authorization': authn
              },
              body: {
                "Body":
                    "You just entered a place where you recorded a memory! Open the Memory Notes app to check it out!",
                "From": sendNum,
                "To": snap["phoneNumber"].toString(),
              });
          FirebaseFirestore.instance
              .collection('entries')
              .doc(snap.data()['entries'][i])
              .update({"status": 1});
          sent = true;
        }
      } else {
        if (location.data()["status"] == 1) {
          FirebaseFirestore.instance
              .collection('entries')
              .doc(snap.data()['entries'][i])
              .update({"status": 0});
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

  void _markerPressed(String title, String locality, String url,
      String songtitle, String songartist) {
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
                child: url == null
                    ? SizedBox.shrink()
                    : Image(
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
                songtitle ?? 'No song title',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
              ),
              Text(
                songartist ?? 'No song artist',
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
    User user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    for (int i = 0; i < snap.data()['entries'].length; i++) {
      DocumentSnapshot location = await FirebaseFirestore.instance
          .collection('entries')
          .doc(snap.data()['entries'][i])
          .get();
      allMarkers.add(new Marker(
        markerId: MarkerId(((location.data()["description"].hashCode +
                    location.data()["coords"].latitude +
                    location.data()["coords"].longitude) *
                Random().nextInt(20))
            .toString()),
        position: LatLng(location.data()["coords"].latitude,
            location.data()["coords"].longitude),
        onTap: () {
          _markerPressed(
              location.data()["title"],
              location.data()["locality"],
              location.data()["imageUrl"],
              location.data()["songartist"],
              location.data()["songtitle"]);
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
        _markerPressed(
            "Current Location",
            "[${currentPos.latitude},${currentPos.longitude}]",
            null,
            "None Available",
            "None Available");
      },
      icon: icon,
    ));
  }
}
