import 'package:flutter/material.dart';
import 'package:memorynotes/utils/StyleConstants.dart';

class AddMemoryScreen extends StatefulWidget {
  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {

  Widget _buildSuggestedSong(String songName, String artist){
    return Container(
      height: 125.0,
      width: 125.0,

      decoration: BoxDecoration(
        color: StyleConstants.backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(songName, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),),
            SizedBox(height: 5.0,),
            Text(artist, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600),),
            IconButton(
              icon: Icon(Icons.play_arrow,),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: StyleConstants.backgroundColor,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,
              ),
              //title text
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('La Centerra', style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('Katy, Texas', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add_a_photo, size: 30.0,),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, size: 30.0,),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.room, size: 30.0,),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10.0,),

              //bottom card thingy
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0,),
                        //text input
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15.0,),
                            Container(height: 150.0,
                                child: VerticalDivider(color: Colors.black, width: 10.0,)),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              height: 150.0,
                              width: width - 100,
                              color: Colors.white,
                              child: TextFormField(
                                decoration: InputDecoration(hintText: "Write a description of this place",
                                border: InputBorder.none),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),

                        //suggested songs
                        SizedBox(height: 20.0,),
                        Text('Suggested Songs', style: TextStyle(fontSize: 30.0),),
                        SizedBox(height: 20.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildSuggestedSong("I want it that way", "Backstreet Boys"),

                            _buildSuggestedSong("I want it that way", "Backstreet Boys"),

                            _buildSuggestedSong("I want it that way", "Backstreet Boys"),
                          ],
                        ),

                        SizedBox(height: 5.0,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          width: double.infinity,
                          child: RaisedButton(
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text('Done'),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
