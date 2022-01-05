import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {

  String user = "Perangkat";
  final ref = FirebaseDatabase.instance.ref('Device/');
  late StreamSubscription streamRef;

  @override
  void initState() {
    getPrefData();
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('username')!;
      print(user);
    });
  }

  void updateData() async{
    await ref.child('$user/').update({
      "reset":"1",
    });
    AppSettings.openWIFISettings();
  }

  void logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 3,
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: (){
                    setState(() {
                      HapticFeedback.lightImpact();
                      updateData();
                    });
                  },
                  child: Container(
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text("RESET SSID",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"
                        ),),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 3,
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: (){
                    setState(() {
                      HapticFeedback.lightImpact();
                      logout();
                    });
                  },
                  child: Container(
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text("LOGOUT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"
                        ),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}