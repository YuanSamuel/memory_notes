import 'package:flutter/material.dart';
import 'package:memorynotes/screens/login_page.dart';
import 'package:memorynotes/screens/onboarding_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: OnboardingScreen(),
    );
  }
}
