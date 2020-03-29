import 'package:flutter/material.dart';
import 'package:memorynotes/screens/view_memory_screen.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_memory_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List<String> locations;
  List<String> localities;
  List<String> imageUrls;
  List<String> musictitles;
  List<String> musicartists;
  List<String> descriptions;
  List<String> songs = ["I Want it that Way", "Haunt Me", "Dat Stick", "Juicy"];
  List<String> artists = ["Backstreet Boys", "Samsa", "Rich Brian", "Doja Cat"];

  int _index = 0;

  String uid;
  String name;
  int numEntries;

  _onAddMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>AddMemoryScreen()));
  }

  _onViewMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => ViewMemoryScreen()));
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }



  getUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap = await Firestore.instance.collection('users').document(user.uid).get();
    uid = user.uid;
    print(uid);
    name = snap["firstName"] + " " + snap["lastName"];
    numEntries = snap["entries"].length;
    imageUrls = new List();
    locations = new List();
    musictitles = new List();
    musicartists = new List();
    localities = new List();
    descriptions = new List();
    for (int i = 0; i < numEntries; i++) {
      DocumentSnapshot snap2 = await Firestore.instance.collection('entries').document(snap["entries"][i]).get();
      localities.add(snap2["locality"]);
      locations.add(snap2["title"]);
      imageUrls.add(snap2["imageUrl"]);
      descriptions.add(snap2["description"]);
      musicartists.add((snap2['songartist']));
      musictitles.add(snap['songtitle']);
    }


    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    if (imageUrls == null) {
      return Scaffold(
        body: CircularProgressIndicator(),
      );}
    else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _onAddMemory(context), backgroundColor: StyleConstants.backgroundColor),
        body: Container(
          //color: StyleConstants.backgroundColor,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0,),
              Text('Your Memories', style: TextStyle(fontSize: 30.0),),
              SizedBox(height: 50.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.mood_bad, size: 35.0,), onPressed: (){},),
                  IconButton(icon: Icon(Icons.sentiment_dissatisfied, size: 35.0), onPressed: (){},),
                  IconButton(icon: Icon(Icons.sentiment_neutral, size: 35.0), onPressed: (){},),
                  IconButton(icon: Icon(Icons.sentiment_satisfied, size: 35.0),  onPressed: (){},),
                  IconButton(icon: Icon(Icons.sentiment_very_satisfied, size: 35.0), onPressed: (){},),
                ],
              ),

              SizedBox(height: 35.0,),

              //gallery
              SizedBox(
                height: 350, // card height
                child: PageView.builder(
                  itemCount: numEntries,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() => _index = index),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewMemoryScreen(uid: uid, title: locations[i],locality: this.localities[i],imageUrl: this.imageUrls[i], description: this.descriptions[i],))),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  height: 350,
                                  width: 300,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image(image: Image.network(imageUrls[i]).image,
                                      fit: BoxFit.cover,),
                                  )
                              ),
                              Positioned(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      locations[i],
                                      style: TextStyle(fontSize: 32, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(Icons.play_arrow, size: 100.0, color: Colors.white,),
                              ),
                              Positioned(
                                bottom: 30,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      musictitles[i],
                                      style: TextStyle(fontSize: 25, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),

                                    Text(
                                      musicartists[i],
                                      style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.center,
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
