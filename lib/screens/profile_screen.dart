import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  _submit(BuildContext context) {}


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
                  Text('Lucas Cai', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),),

                  SizedBox(height: 10.0,),

                  Container(
                      child: Divider(color: Colors.black,),
                    width: 250.0,
                  ),

                  SizedBox(height: 10.0),

                  Text('200 Memories Recorded', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.white),),

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
                                onPressed: () => _submit(context),
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
                            )

                          ],
                        ),
                      ),
                    ),
                  ),

                  /*Expanded(
                    child: Container(
                      //height: 400.0,
                      child:GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
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
                  )*/


                ],

        ),
      ),
    );
  }
}
