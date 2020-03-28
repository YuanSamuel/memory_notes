import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorynotes/main.dart';

import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  @override
  void initState() {
    super.initState();
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length < 8) {
      return 'Password length must be greater than 8 characters';
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[300],
        height: double.infinity,
        child: Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Register!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              Column(
                children: <Widget>[

                  TextFormField(
                    controller: firstNameInputController,
                    decoration: InputDecoration(
                      labelText: "First Name:",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value.length < 1)
                        return 'Please Enter a Valid First Name';
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  TextFormField(
                    controller: lastNameInputController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: "Last Name:",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        )
                      )
                    ),
                    validator: (value) {
                      if (value.length < 1) {
                        return 'Please Enter a Valid Last Name';
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  TextFormField(
                    controller: emailInputController,
                    validator: emailValidator,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      labelText: "Email: ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        )
                      )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  TextFormField(
                    controller: passwordInputController,
                    obscureText: true,
                    validator: passwordValidator,
                    decoration: InputDecoration(
                      labelText: "Password:",
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    ),
                  ),
                ],
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () {
                  if (_registerFormKey.currentState.validate()) {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailInputController.text, password: passwordInputController.text).then(
                        (currentUser) {
                          Firestore.instance.collection('users').document(currentUser.user.uid).setData({"uid": currentUser.user.uid,
                            "firstName": firstNameInputController.text,
                            "lastName": lastNameInputController.text,
                            "email": emailInputController.text,
                          });
                        }
                    );
                    firstNameInputController.clear();
                    lastNameInputController.clear();
                    emailInputController.clear();
                    passwordInputController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}