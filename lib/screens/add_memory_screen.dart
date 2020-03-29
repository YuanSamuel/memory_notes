import 'package:flutter/material.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddMemoryScreen extends StatefulWidget {
  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {

  Widget _nowPlayingPanel(){
    return Container(
      //height: 10.0,
      color: StyleConstants.backgroundColorDark,
      child: Row(
        children: <Widget>[
          //little picture
          Container(
            height: 60.0,
            width: 60.0,
            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
          ),
          SizedBox(width: 10.0,),
          //song name and artist
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('I Want it that Way', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400),),
              Text('Backstreet Boys', style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),),
            ],
          ),
          Spacer(),
          IconButton(icon: Icon(Icons.play_arrow, size: 30.0,), onPressed: () {},),
        ],
      )
    );
  }

  Widget _buildSuggestedSong(String songName, String artist){
    return Container(

      //height: 125.0,
      //width: 125.0,
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

    return
      Scaffold(
        backgroundColor: StyleConstants.backgroundColor,
        appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        ),
        body: SlidingUpPanel(
            panel: _nowPlayingPanel(),
            minHeight: 60.0,
            maxHeight: 60.0,
            backdropColor: StyleConstants.backgroundColor,

      //backdropEnabled: true,
      //backdropOpacity: 0.5,

        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height * 0.9,
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
                SizedBox(height: 25.0,),
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
                SizedBox(height: 20.0,),

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
                          //text input one
                          Row(
                            children: <Widget>[
                              SizedBox(width: 15.0,),
                              Container(height: 50.0,
                                  child: VerticalDivider(color: Colors.black, width: 10.0,)),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                height: 50.0,
                                width: width - 100,
                                color: Colors.white,
                                child: TextFormField(
                                  decoration: InputDecoration(hintText: "How does this place make you feel",
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),

                          //text input
                          Row(
                            children: <Widget>[
                              SizedBox(width: 15.0,),
                              Container(height: 200.0,
                                  child: VerticalDivider(color: Colors.black, width: 10.0,)),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                height: 200.0,
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
                          /*
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
*/
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
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
