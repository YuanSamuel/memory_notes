import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  String uid;
  String name;
  int numEntries;

  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    User user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      uid = user.uid;
      name = snap["firstName"] + " " + snap["lastName"];
      numEntries = snap["entries"].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        color: StyleConstants.backgroundColor,
        width: width,
        height: height + 300,
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  CircleAvatar(backgroundImage: AssetImage('assets/images/profilepic.jpg'), radius: 75.0,),
                  SizedBox(height: 10.0,),
                  name == null ? Text('Loading...', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),) :
                  Text(name, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),

                  SizedBox(height: 10.0,),

                  Container(
                      child: Divider(color: Colors.black,),
                    width: 250.0,
                  ),

                  SizedBox(height: 10.0),

                  numEntries == null ? Text('Loading...', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),) :
                  Text('${numEntries} Entries Recorded', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),),

                  SizedBox(height: 10.0,),

                  Container(
                    child: Divider(color: Colors.black,),
                    width: 250.0,
                  ),


                  SizedBox(height: 30.0,),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),

                            //text input
                            Row(
                              children: <Widget>[
                                SizedBox(width: 15.0,),
                                Container(height: 250.0,
                                    child: VerticalDivider(color: Colors.black, width: 10.0,)),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 250.0,
                                  width: width - 100,
                                  color: Colors.white,
                                  child: TextFormField(
                                    //onChanged: onParagraphChanged,
                                    decoration: InputDecoration(
                                        hintText:
                                        "Write about yourself",
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.multiline,
                                    //controller: descriptionInputController,
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25.0),
                              width: double.infinity,
                              child: IconButton(icon: Icon(Icons.check),
                                color: StyleConstants.backgroundColor,
                                onPressed: () {},
                              ),
                            ),

                            SizedBox(height: 40.0,),

                            Container(
                              height: 250.0,
                              width: 250.0,

                              decoration: BoxDecoration(
                                color: StyleConstants.backgroundColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Spacer(),
                                  Icon(Icons.play_arrow, size: 40.0, color: Colors.white,),
                                  SizedBox(height: 50.0,),
                                  Text('I want it that way', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),),
                                  Text('Backstreet Boys', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400,)),
                                  SizedBox(height: 20.0,)
                                ],
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                            )

                          ],
                        ),
                      ),
                    ),
                  ),



                ],

        ),
      ),
    );
  }
}
