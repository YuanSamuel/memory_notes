import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  List<String> locations = ["La Centerra", "Cinco Ranch", "Creech Elementary", "Home"];
  List<String> locationsImgs = ["assets/images/1.jpg", "assets/images/2.jpg", "assets/images/3.jpg", "assets/images/1.jpg"];

  int _index = 0;


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text('Your Memories', style: TextStyle(fontSize: 30.0),),
          SizedBox(height: 50.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(icon: Icon(Icons.mood_bad), onPressed: (){},),
              IconButton(icon: Icon(Icons.sentiment_dissatisfied), onPressed: (){},),
              IconButton(icon: Icon(Icons.sentiment_neutral), onPressed: (){},),
              IconButton(icon: Icon(Icons.sentiment_satisfied),  onPressed: (){},),
              IconButton(icon: Icon(Icons.sentiment_very_satisfied), onPressed: (){},),
            ],
          ),

          SizedBox(height: 75.0,),

          //gallery
          SizedBox(
            height: 300, // card height
            child: PageView.builder(
              itemCount: locations.length,
              controller: PageController(viewportFraction: 0.7),
              onPageChanged: (int index) => setState(() => _index = index),
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: i == _index ? 1 : 0.9,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                            child: Image.asset('assets/images/1.jpg', fit: BoxFit.cover,)),
                        Center(
                          child: Text(
                            locations[i],
                            style: TextStyle(fontSize: 32),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
