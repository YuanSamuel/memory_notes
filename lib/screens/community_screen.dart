import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {


  List<String> people = ["John Smith", "Samuel Yuan", "Lucas Cai", "Prasann"];
  List<String> peopleImgs = ["assets/images/profilepic.jpg", "assets/images/profilepic.jpg", "assets/images/profilepic.jpg", "assets/images/profilepic.jpg"];
  List<String> songs = ["I Want it that Way", "Haunt Me", "Dat Stick", "Juicy"];
  List<String> artists = ["Backstreet Boys", "Samsa", "Rich Brian", "Doja Cat"];

  int _index = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add
      ), onPressed: () {}
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0,
            ),
            Text('People', style: TextStyle(fontSize: 30.0
            ),
            ),
            SizedBox(height: 50.0,
            ),

            SizedBox(height: 35.0,
            ),

            //gallery
            SizedBox(
              height: 350, // card height
              child: PageView.builder(
                itemCount: people.length,
                controller: PageController(viewportFraction: 0.7
                ),
                onPageChanged: (int index) =>
                    setState(() => _index = index
                    ),
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20
                          )
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: 350,
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0
                                  )
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0
                                  ),
                                  child: Image.asset(peopleImgs[i],
                                    fit: BoxFit.cover,
                                  )
                              )
                          ),
                          Positioned(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0
                                ),
                                child: Text(
                                  people[i],
                                  style: TextStyle(
                                      fontSize: 32, color: Colors.white
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(Icons.play_arrow, size: 100.0,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  songs[i],
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                Text(
                                  artists[i],
                                  style: TextStyle(fontSize: 21,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        ],
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
