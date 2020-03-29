import 'dart:math';

class SongResult {
  final String artist;
  final String title;

  SongResult({this.artist, this.title,});

  static int randval(int a){
    if(a!=null){
      return a;
    }
    Random r = new Random();
    if(r.nextInt(10)>5){
      return 10;
    }
    return null;
  }

  factory SongResult.fromJson(Map<String, dynamic> json) {
    return SongResult(
      artist: json['artist'],
      title:json['title'],
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return artist.toString()+" "+title.toString();
  }

}