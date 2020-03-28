import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorynotes/main.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: double.infinity,
        color: Colors.blue[300],
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Music Notes',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailInputController,
                    validator: emailValidator,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Email:",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  TextFormField(
                    controller: passwordInputController,
                    validator: passwordValidator,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Password:",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ))),
                  ),
                ],
              ),
              RaisedButton(
                child: Text("Login"),
                color: Colors.white,
                textColor: Colors.blue,
                onPressed: () {
                  if (_loginFormKey.currentState.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailInputController.text,
                            password: passwordInputController.text)
                        .then((currentUser) {
                      Firestore.instance
                          .collection("users")
                          .document(currentUser.user.uid)
                          .get();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: 'test')),
                    );
                  }
                },
              ),
              FlatButton(
                child: Text("Register Here!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
