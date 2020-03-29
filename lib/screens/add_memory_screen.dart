import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:memorynotes/api/api_client.dart';
import 'package:memorynotes/api/song_result.dart';
import 'package:memorynotes/music_app/musicservice.dart';
import 'package:memorynotes/music_app/search.dart';
import 'package:memorynotes/music_app/song.dart';
import 'package:memorynotes/utils/StyleConstants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:io';
import 'dart:async';

class AddMemoryScreen extends StatefulWidget {
  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  int punct = 0;
  double totalscore = 0;
  double scores = 0;
  String mood = "";
  SongResult nowsong;
  Song cursong;

  Widget _nowPlayingPanel() {
    print(cursong);
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
                      fontWeight: FontWeight.w400),
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

  @override
  void initState() {
    super.initState();

    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    setState(() {
      nowsong = new SongResult(title: "The Box", artist: "Roddy Ricch");
    });

    initializeDateFormatting();
  }

  bool _isPlaying = false;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

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

  _seekToPlayer(int milliSecs) async {
    int secs = Platform.isIOS ? milliSecs / 1000 : milliSecs;

    if (_playerSubscription == null) {
      return;
    }

    String result = await flutterSound.seekToPlayer(secs);
    print('seekToPlayer: $result');
  }

  Future<Search> _search;
  String _searchTextInProgress;
  AppleMusicStore musicStore = AppleMusicStore.instance;

  void onParagraphChanged(text) {
    var l = text[text.length - 1];
    if (l == '.' || l == '?' || l == '!') {
      fetchSentimentResult(text.substring(punct)).then((result) {
        setState(() {
          totalscore = totalscore + result.score;
          scores = scores + 1;
          punct = text.length;
        });
      });
    }
    if (scores % 4 == 0) {
      fetchSongResult((totalscore / scores), mood).then((result) {
        //TODO Change Song Here
        var rand = new Random();
        setState(() {
          nowsong = result[rand.nextInt(result.length)];
          _search = musicStore.search(nowsong.title);
        });
      });
    }
  }

  void onMoodChanged(text) {
    setState(() {
      mood = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: StyleConstants.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: SlidingUpPanel(
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

        //backdropEnabled: true,
        //backdropOpacity: 0.5,

        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height * 0.9,
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
                    'La Centerra',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Katy, Texas',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30.0,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        size: 30.0,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.room,
                        size: 30.0,
                      ),
                      onPressed: () {},
                    ),
                  ],
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
                                child: TextFormField(
                                  onChanged: onMoodChanged,
                                  decoration: InputDecoration(
                                      hintText:
                                          "How does this place make you feel",
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
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
                                  height: 200.0,
                                  child: VerticalDivider(
                                    color: Colors.black,
                                    width: 10.0,
                                  )),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                height: 200.0,
                                width: width - 100,
                                color: Colors.white,
                                child: TextFormField(
                                  onChanged: onParagraphChanged,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Write a description of this place",
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            width: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text('Done'),
                              onPressed: () {
                                //TODO Insert Database Insertion Code
                              },
                            ),
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
