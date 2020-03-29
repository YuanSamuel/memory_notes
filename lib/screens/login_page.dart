import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memorynotes/main.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
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

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: StyleConstants.loginLabelTextStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: StyleConstants.loginBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emailInputController,
            validator: emailValidator,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: StyleConstants.loginHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: StyleConstants.loginLabelTextStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: StyleConstants.loginBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: passwordInputController,
            validator: passwordValidator,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: StyleConstants.loginHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {return HomeScreen();}),
              );
            });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: double.infinity,
          color: Colors.blue[300],
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(
                  'Memory Notes',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),

                SizedBox(height: 50,),

                Column(
                  children: <Widget>[
                    _buildEmailTF(),
                    //email
                    /*
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
                    ),*/

                    SizedBox(height: 20.0,),

                    //password
                    _buildPasswordTF(),
                    /*TextFormField(
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
                    ),*/

                  ],
                ),
                SizedBox(height: 10.0,),
                //login
                _buildLoginBtn(),
                /*
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
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  },
                ),
                */
                //signup button
                _buildSignupBtn(),
                /*
                FlatButton(
                  child: Text("Register Here!"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
