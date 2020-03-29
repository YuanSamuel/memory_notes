import 'dart:math';

class SentimentResult {
  final double score;
  final double magnitude;

  SentimentResult({this.score, this.magnitude,});

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

  factory SentimentResult.fromJson(Map<String, dynamic> json) {
    return SentimentResult(
      score: json['score'],
      magnitude: json['magnitude'],
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return score.toString()+" "+magnitude.toString();
  }

}