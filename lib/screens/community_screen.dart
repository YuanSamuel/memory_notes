import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  static String uname = 'ACd2fc0b0525c64d3aad7ab1e4990df8d3';
  static String pword = '53cacf2f6d17a96a1b14acb0c2f22fee';
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: FlatButton(
            child: Text("send"),
            onPressed: () {
              post("https://api.twilio.com/2010-04-01/Accounts/ACd2fc0b0525c64d3aad7ab1e4990df8d3/Messages.json", headers: {'Authorization': authn}, body: {"Body":"8:43","From":"+12512505464","To":"+18326611103"});
              setState(() {
                number++;
              });
            },
          ),
        )
    );
  }
}
