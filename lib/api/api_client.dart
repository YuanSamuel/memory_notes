import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:memorynotes/api/sentiment_result.dart';
import 'package:memorynotes/api/song_result.dart';
import 'package:memorynotes/music_app/song.dart';


Future<SentimentResult> fetchSentimentResult(String text) async {

  String url = 'http://192.168.0.116:8080/api/?input='+text;
  print(url);
  Response response = await get(url);
  // sample info available in response
  //int statusCode = response.statusCode;
  print(response.body);
  SentimentResult footprintResult = SentimentResult.fromJson(json.decode(response.body));

  print(footprintResult);
  return footprintResult;

}

Future<List<SongResult>> fetchSongResult(double sentiment, String mood) async {

  String url = 'http://192.168.0.116:8080/song/?sentiment='+sentiment.toString()+"&"+"mood="+mood;
  Response response = await get(url);
  // sample info available in response
  //int statusCode = response.statusCode;
  print(response.body);
  var j = json.decode(response.body);
  List<SongResult> songs = [];
  for(Map<String, dynamic> m in j['response']){
    songs.add(SongResult.fromJson(m));
  }

  print(songs);
  return songs;

}