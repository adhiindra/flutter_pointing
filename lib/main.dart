import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'maps.dart';
import 'pointing.dart';
import 'setting.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.lightBlue, // navigation bar color
    statusBarColor: Colors.lightBlue, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AnimatedSplashScreen(
      duration: 3000,
      splash: Container(
        child: Icon(
          Icons.settings_input_antenna,
          color: Colors.white,
          size: 100,
        ),
      ),
      nextScreen: home(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.lightBlue,),
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _checkPermission());
  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    return;
  }
  int locationStatus = 0;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    pointing(),maps(),setting(),
  ];

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.lightBlueAccent,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/download.jpg'),
                        radius: 30,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Perangkat Penatih - Gianyar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: <Widget>[
                              Text(
                                'BTS',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                'Client',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 25,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.lightBlueAccent,
                    color: Colors.lightBlueAccent,
                    tabs: [
                      GButton(
                        icon: Icons.compare_arrows,
                        text: 'Pointing',
                      ),
                      GButton(
                        icon: Icons.map,
                        text: 'Maps',
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Setting',
                      ),
                    ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index){
                      setState(() {
                        _selectedIndex = index;
                      });
                  },
                ),
              ),
              Divider(
              color: Colors.grey[300],
              thickness: 1,
              ),
              _widgetOptions.elementAt(_selectedIndex),
            ],
          ),
        ),
    );
  }
}



