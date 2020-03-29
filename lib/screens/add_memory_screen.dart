import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:location/location.dart' as lo;
import 'package:geocoder/geocoder.dart';

class AddMemoryScreen extends StatefulWidget {
  AddMemoryScreen({Key key, this.locationData, this.address}) : super(key: key);
  final lo.LocationData locationData;
  final Address address;
  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  TextEditingController feelingInputController;
  TextEditingController descriptionInputController;
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();
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

  File _image;
  FlutterSound flutterSound = new FlutterSound();

  void initState() {
    super.initState();
    initSpeechState();
    feelingInputController = new TextEditingController();
    descriptionInputController = new TextEditingController();
    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);

    setState(() {
      nowsong = new SongResult(title: "The Box", artist: "Roddy Ricch");
    });

    initializeDateFormatting();
  }

  Future<void> initSpeechState() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    print(permission);
    bool hasSpeech = await speech.initialize(onStatus: statusListener);
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
    print('init');
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    await uploadImage();
  }

  Future uploadImage() async {
    print(Path.basename(_image.path));
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("photos/${Path.basename(_image.path)}");
    StorageUploadTask upload = reference.putFile(_image);
    await upload.onComplete;
    print('complete');
  }

  Future getRecording() async {
    startListening();
    print("listening");
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

  _submit(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String url = await FirebaseStorage.instance
        .ref()
        .child("photos/${Path.basename(_image.path)}")
        .getDownloadURL();
    DocumentReference ref = await Firestore.instance.collection('entries').add({
      "imageUrl": url,
      "uid": user.uid,
      "description":descriptionInputController.text,
      "coords":
          GeoPoint(widget.locationData.latitude, widget.locationData.longitude)
    });
    DocumentSnapshot snap = await Firestore.instance.collection('users').document(user.uid).get();
    List hold = snap['entries'];
    hold.add(ref.documentID);
    Firestore.instance.collection('users').document(user.uid).updateData({"entries":hold});
    Navigator.pop(context);
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
                    widget.address.featureName,
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
                    widget.address.locality,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 25.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getRecording();
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.room,
                          size: 30.0,
                        ),
                        onPressed: () {}),
                  ],
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
                                  controller: feelingInputController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),

                          //text input
                          Row(
                            children: <Widget>[
                              SizedBox(width: 15.0,),
                              Container(height: 200.0,
                                  child: VerticalDivider(color: Colors.black, width: 10.0,)),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                height: 250.0,
                                width: width - 100,
                                color: Colors.white,
                                child: TextFormField(
                                  onChanged: onParagraphChanged,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Write a description of this place",
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.multiline,
                                  controller: descriptionInputController,
                                  maxLines: null,
                                ),
                              ),
                            ],
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
                              onPressed: () => _submit(context),
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

  void startListening() {
    print("START LISTENING");
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener, listenFor: Duration(seconds: 59));
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      descriptionInputController.text = lastWords;
      print(lastWords);
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
