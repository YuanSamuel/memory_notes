import 'package:flutter/material.dart';
import 'package:memorynotes/music_app/main.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/login_page.dart';
import 'package:memorynotes/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/login_page.dart';
import 'package:memorynotes/screens/onboarding_screen.dart';

void main() => runApp(MusicApp());

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
      home: AddMemoryScreen(),
    );
  }
}
