import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:memorynotes/api/song_result.dart';
import 'package:memorynotes/music_app/musicservice.dart';
import 'package:memorynotes/music_app/search.dart';
import 'package:memorynotes/music_app/song.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:intl/intl.dart';


class ViewMemoryScreen extends StatefulWidget {
  ViewMemoryScreen({Key key, this.uid, this.title, this.locality, this.imageUrl, this.description, this.songtitle, this.songartist}):super(key: key);
  final String title;
  final String uid;
  final String locality;
  final String imageUrl;
  final String description;
  final String songtitle;
  final String songartist;
  @override
  _ViewMemoryScreenState createState() => _ViewMemoryScreenState();
}

class _ViewMemoryScreenState extends State<ViewMemoryScreen> {

  Song cursong;
  SongResult nowsong;
  FlutterSound flutterSound = new FlutterSound();
  AppleMusicStore musicStore = AppleMusicStore.instance;

  void initState() {
    super.initState();



    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    setState(() {
      nowsong = new SongResult(title: widget.songtitle, artist: widget.songartist);
      _search = musicStore.search(nowsong.title);
    });

  }

  Widget _nowPlayingPanel() {

    return Container(
      //height: 10.0,
        color: StyleConstants.backgroundColorDark,
        child: Row(
          children: <Widget>[
            //little picture
            Container(
              height: 60.0,
              width: 60.0,
              child: Image.network(
                cursong.artworkUrl(512),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            //song name and artist
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cursong.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.clip,
                ),
                Text(
                  cursong.artistName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                if (_isPlaying) {
                  _pausePlayer();
                } else {
                  if (_playerSubscription == null) {
                    this.setState(() {
                      this._isPlaying = true;
                    });
                    Timer(Duration(milliseconds: 200), () {
                      startPlayer(cursong.previewUrl);
                    });
                  } else {
                    _resumePlayer();
                  }
                }
              },
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: _isPlaying
                    ? AssetImage('res/icons/ic_pause.png')
                    : AssetImage('res/icons/ic_play.png'),
              ),
            ),
          ],
        ));
  }


  bool _isPlaying = false;
  StreamSubscription _playerSubscription;

  String _startText = '00:00';
  String _endText = '00:00';
  double slider_current_position = 0.0;
  double max_duration = 1.0;

  void startPlayer(String uri) async {
    String path = await flutterSound.startPlayer(uri);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) async {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;

          final remaining = e.duration - e.currentPosition;

          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);

          DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
              remaining.toInt(),
              isUtc: true);

          String startText = DateFormat('mm:ss', 'en_GB').format(date);
          String endText = DateFormat('mm:ss', 'en_GB').format(endDate);

          if (this.mounted) {
            this.setState(() {
              this._startText = startText;
              this._endText = endText;
              this.slider_current_position = slider_current_position;
              this.max_duration = max_duration;
            });
          }
        } else {
          slider_current_position = 0;

          if (_playerSubscription != null) {
            _playerSubscription.cancel();
            _playerSubscription = null;
          }
          this.setState(() {
            this._isPlaying = false;
            this._startText = '00:00';
            this._endText = '00:00';
          });
        }
      });
    } catch (err) {
      print('error: $err');
      this.setState(() {
        this._isPlaying = false;
      });
    }
  }

  _pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
    this.setState(() {
      this._isPlaying = false;
    });
  }

  _resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
    this.setState(() {
      this._isPlaying = true;
    });
  }

  Future<Search> _search;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return
      SlidingUpPanel(
        panel: _search != null
            ? FutureBuilder<Search>(
          future: _search,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState != ConnectionState.waiting) {
              final searchResult = snapshot.data;

              List<Song> songs = searchResult.songs;
              if (songs.length >= 5) {
                songs = songs.sublist(0, 5);
              }

              if (songs.length > 0 && songs.length < 5) {
                songs = songs.sublist(0, songs.length);
              }

              final List<Widget> list = [];
              List<Song> sons = [];

              for (Song song in songs) {
                print("SONGS" + songs.toString());
                if (song.title.toLowerCase() ==
                    nowsong.title.toLowerCase() &&
                    song.artistName.toLowerCase() ==
                        nowsong.artist.toLowerCase()) {
                  sons.add(song);
                }
              }

              if (sons.length == 0) {
                sons.add(songs[0]);
              }
              cursong = sons[0];

              return _nowPlayingPanel();
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }

            return Center(child: CircularProgressIndicator());
          },
        )
            : Center(child: Text('Type on search bar to begin')),
        minHeight: 60.0,
        maxHeight: 60.0,
        backdropColor: StyleConstants.backgroundColor,
        body: Scaffold(
          backgroundColor: StyleConstants.backgroundColor,
          appBar: AppBar(
            elevation: 0.0,
            leading: BackButton(
              color: Colors.black,
            ),
            backgroundColor: StyleConstants.backgroundColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(
                    height: 10,
                  ),
                  //title text
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.locality,
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  //bottom card thingy
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),

                            Container(
                              height: 100.0,
                              width: 100.0,
                              child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,),
                              color: Colors.blue,
                            ),

                            SizedBox(
                              height: 10.0,
                            ),

                            //text input one
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                    height: 50.0,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      width: 10.0,
                                    )),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 50.0,
                                  width: width - 100,
                                  color: Colors.white,
                                  child: Text(
                                    'Happy '
                                  ),
                                ),
                              ],
                            ),

                            //text input
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                    height: 250.0,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      width: 10.0,
                                    )),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  height: 250.0,
                                  width: width - 100,
                                  color: Colors.white,
                                  child: Text(
                                    widget.description,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
