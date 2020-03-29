import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:memorynotes/screens/view_memory_screen.dart';
import 'package:memorynotes/utils/StyleConstants.dart';

import 'add_memory_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List<String> locations = ["La Centerra", "Cinco Ranch", "Creech Elementary", "Home"];
  List<String> locationsImgs = ["assets/images/1.jpg", "assets/images/2.jpg", "assets/images/3.jpg", "assets/images/1.jpg"];
  List<String> songs = ["I Want it that Way", "Haunt Me", "Dat Stick", "Juicy"];
  List<String> artists = ["Backstreet Boys", "Samsa", "Rich Brian", "Doja Cat"];

  int _index = 0;

  _onAddMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>AddMemoryScreen()));
  }

  _onViewMemory(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => ViewMemoryScreen()));
  }


  @override
  Widget build(BuildContext context) {
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
                itemCount: locations.length,
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewMemoryScreen())),
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
                                    child: Image.asset(locationsImgs[i],
                                      fit: BoxFit.cover,)
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
                                    songs[i],
                                    style: TextStyle(fontSize: 25, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),

                                  Text(
                                    artists[i],
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
