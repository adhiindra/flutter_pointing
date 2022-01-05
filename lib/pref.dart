import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepref extends StatefulWidget {
  const Homepref({Key? key}) : super(key: key);

  @override
  _HomeprefState createState() => _HomeprefState();
}

class _HomeprefState extends State<Homepref> {

  @override
  void initState() {
    super.initState();
    getPrefData();
  }

  void getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('username')!=null){
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

