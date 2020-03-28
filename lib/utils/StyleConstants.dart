import 'package:flutter/material.dart';

class StyleConstants{
  static TextStyle onboardingText = TextStyle(fontSize: 20.0, color: Colors.white );

  static TextStyle loginHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  static TextStyle loginLabelTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  static BoxDecoration loginBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  static TextStyle answerText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: 20,
  );

  static final textAnswer = TextStyle(
    color: Colors.white,
    //fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: 15,
  );

}

