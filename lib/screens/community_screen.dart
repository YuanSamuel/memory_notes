import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {


  List<String> people = ["John", "Samuel", "Lucas", "Prasann"];
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
            SizedBox(height: 30.0,),
            Text('People', style: TextStyle(fontSize: 30.0),),
            Container(
              height: 600.0,
              child: ListView.builder(
                itemCount: people.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100.0,
                        child: Row(
                          children: <Widget>[
                            Container(

                              height: 100.0,
                              width: 100.0,
                              child: CircleAvatar(
                                radius: 75.0,
                                backgroundImage: AssetImage('assets/images/profilepic.jpg'),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(people[index], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
                            ),

                            Spacer(),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                Text('I want it that way', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),),
                                SizedBox(height: 10.0,),
                                Text('Backstreet Boys'),
                              ],
                            ),

                            SizedBox(width: 10.0,),
                            Icon(Icons.play_arrow),
                          ],
                        )

                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
