import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:async';
import 'musicservice.dart';
import 'song.dart';

class PlayerWidget extends StatefulWidget {
  PlayerWidget({Key key, this.song}) : super(key: key);
  final Song song;

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final musicStore = AppleMusicStore.instance;
  bool _isPlaying = false;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _startText = '00:00';
  String _endText = '00:00';
  double slider_current_position = 0.0;
  double max_duration = 1.0;

  @override
  void initState() {
    super.initState();

    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    initializeDateFormatting();
  }

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

  @override
  void dispose() async {
    super.dispose();
    await flutterSound.stopPlayer();
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  Widget _nowPlayingPanel(){
    print(widget.song);
    return Container(
      //height: 10.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            //little picture
            Container(
              height: 60.0,
              width: 60.0,
              child: Image.network(
                widget.song.artworkUrl(512),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.0,),
            //song name and artist
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.song.title, style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400),),
                Text(widget.song.artistName, style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),),
              ],
            ),
            Spacer(),
            FlatButton(
              onPressed: (){
                if (_isPlaying) {
                  _pausePlayer();
                } else {
                  if (_playerSubscription == null) {
                    this.setState(() {
                      this._isPlaying = true;
                    });
                    Timer(Duration(milliseconds: 200), () {
                      startPlayer(widget.song.previewUrl);
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
        )
    );
  }
  
  

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child:_nowPlayingPanel() );
  }
}
