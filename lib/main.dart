import 'package:flutter/material.dart';
import 'package:memorynotes/api/api_client.dart';
import 'package:memorynotes/api/sentiment_result.dart';
import 'package:memorynotes/api/song_result.dart';
import 'package:memorynotes/music_app/main.dart';
import 'package:memorynotes/music_app/song.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/login_page.dart';
import 'package:memorynotes/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:memorynotes/screens/add_memory_screen.dart';
import 'package:memorynotes/screens/home_screen.dart';
import 'package:memorynotes/screens/login_page.dart';
import 'package:memorynotes/screens/onboarding_screen.dart';



Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

/*
  Future<SentimentResult> s = fetchSentimentResult("Hello World!");

  s.then((result){
    Future<List<SongResult>> s = fetchSongResult(result.score, "Happy");
    s.then((songresult){
      print(songresult);
    });
  });*/

  // Obtain a list of the available cameras on the device.
  //final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  //final firstCamera = cameras.first;

  runApp(MyApp());
}

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
