import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot snap = await Firestore.instance.collection('users').document(user.uid).get();

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

                  Text('Favorite Memories', style: TextStyle(fontSize: 30.0),),

                  SizedBox(height: 15.0,),


                  Expanded(
                    child: Container(
                      //height: 400.0,
                      child:GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: 2,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                          ),
                        ],
                      )
                    ),
                  )


                ],

        ),
      ),
    );
  }
}
