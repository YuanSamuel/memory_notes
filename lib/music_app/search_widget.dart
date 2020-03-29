import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memorynotes/music_app/album.dart';
import 'cupertino_search_bar.dart';
import 'search.dart';
import 'musicservice.dart';
import 'carousel_song_widget.dart';
import 'carousel_album.dart';
import 'divider_widget.dart';
import 'artist_widget.dart';
import 'artist.dart';
import 'song.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
}

class SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchTextController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  Animation _animation;
  AnimationController _animationController;
  Future<Search> _search;
  AppleMusicStore musicStore = AppleMusicStore.instance;
  String _searchTextInProgress;

  @override
  initState() {
    super.initState();

    _animationController = new AnimationController(
      duration: new Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _searchFocusNode.addListener(() {
      if (!_animationController.isAnimating) {
        _animationController.forward();
      }
    });

    _searchTextController.addListener(_performSearch);
  }

  _performSearch() {
    print("HELLO FROM THE OTHER SIDE");
    final text = "Hello";
    if (_search != null && text == _searchTextInProgress) {
      return;
    }

    if (text.isEmpty) {
      this.setState(() {
        _search = null;
        _searchTextInProgress = null;
      });
      return;
    }

      this.setState(() {
      _search = musicStore.search(text);
      _searchTextInProgress = text;
    });
  }

  _cancelSearch() {
    _searchTextController.clear();
    _searchFocusNode.unfocus();
    _animationController.reverse();
    this.setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  _clearSearch() {
    _searchTextController.clear();
    this.setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  @override
  dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: IOSSearchBar(
        controller: _searchTextController,
        focusNode: _searchFocusNode,
        animation: _animation,
        onCancel: _cancelSearch,
        onClear: _clearSearch,
      )),
      child: GestureDetector(
        onTapUp: (TapUpDetails _) {
          _searchFocusNode.unfocus();
          if (_searchTextController.text == '') {
            _animationController.reverse();
          }
        },
        child: _search != null
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

                    for(Song song in songs){
                      if(song.title.toLowerCase()=='in the mood'){
                        sons.add(song);
                      }
                    }

                    if (songs != null && songs.isNotEmpty) {
                      list.add(Padding(
                        padding: EdgeInsets.only(top: 16),
                      ));
                      list.add(CarouselSongWidget(
                        title: 'Songs',
                        songs: sons,
                      ));
                    }


                    return ListView(
                      children: list,
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return Center(child: CircularProgressIndicator());
                },
              )
            : Center(
                child: Text(
                    'Type on search bar to begin')), // Add search body here
      ),
    );
  }
}
