import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:memorynotes/screens/community_screen.dart';
import 'package:memorynotes/screens/gallery_screen.dart';
import 'package:memorynotes/screens/map_screen.dart';
import 'package:memorynotes/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  var _pageOptions = [
    MapScreen(),
    GalleryScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.75)
            )
          ],
          color: Colors.blue,
        ),
        child: CurvedNavigationBar(
          backgroundColor: Colors.grey[200],
          items: <Widget>[
            Icon(Icons.calendar_today, size: 30),
            Icon(Icons.insert_chart, size: 30),
            Icon(Icons.people, size: 30),
            Icon(Icons.person_pin, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
      ),
    );
  }
}