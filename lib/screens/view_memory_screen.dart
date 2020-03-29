import 'package:flutter/material.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:path/path.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ViewMemoryScreen extends StatefulWidget {
  ViewMemoryScreen({Key key, this.uid, this.title, this.locality, this.imageUrl, this.description}):super(key: key);
  final String title;
  final String uid;
  final String locality;
  final String imageUrl;
  final String description;
  @override
  _ViewMemoryScreenState createState() => _ViewMemoryScreenState();
}

class _ViewMemoryScreenState extends State<ViewMemoryScreen> {

  Widget _nowPlayingPanel() {
    return Scaffold(
      body: Container(
        //height: 10.0,
          color: StyleConstants.backgroundColorDark,
          child: Row(
            children: <Widget>[
              //little picture
              Container(
                height: 60.0,
                width: 60.0,
                child: Image(
                  image: Image.network(widget.imageUrl).image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              //song name and artist
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'I Want it that Way',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Backstreet Boys',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  size: 30.0,
                ),
                onPressed: () {},
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return
      SlidingUpPanel(
        panel: _nowPlayingPanel(),
        minHeight: 60.0,
        maxHeight: 60.0,
        backdropColor: StyleConstants.backgroundColor,
        body: Scaffold(
          backgroundColor: StyleConstants.backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            leading: BackButton(
              color: Colors.black,
            ),
            backgroundColor: StyleConstants.backgroundColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(
                    height: 10,
                  ),
                  //title text
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.locality,
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  //bottom card thingy
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              height: 100.0,
                              width: 100.0,
                              child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                              color: Colors.blue,
                            ),

                            SizedBox(
                              height: 10.0,
                            ),

                            //text input one
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                    height: 50.0,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      width: 10.0,
                                    )),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 50.0,
                                  width: width - 100,
                                  color: Colors.white,
                                  child: Text(
                                    'Happy '
                                  ),
                                ),
                              ],
                            ),

                            //text input
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                    height: 250.0,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      width: 10.0,
                                    )),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 250.0,
                                  width: width - 100,
                                  color: Colors.white,
                                  child: Text(
                                    widget.description,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
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
