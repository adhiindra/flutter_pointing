import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointing/login.dart';
import 'package:pointing/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    theme: ThemeData(
      fontFamily: 'Montserrat',
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
      ),
    ),
    home: AnimatedSplashScreen(
      duration: 3000,
      splash: Container(
        child: Icon(
          Icons.settings_input_antenna,
          color: Colors.white,
          size: 100,
        ),
      ),
      nextScreen: Homepref(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.lightBlue,),
    routes: <String, WidgetBuilder> {
      '/login': (BuildContext context) => new Login(),
      '/home' : (BuildContext context) => new home(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  String username = "Perangkat";

  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _checkPermission());
    getPrefData();
  }

  void getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      print(username);
    });
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
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                      backgroundColor: Colors.lightBlue,
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
                            '$username',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'
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
                                  fontFamily: 'Montserrat'
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                'Client',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontFamily: 'Montserrat'
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
                    tabBackgroundColor: Colors.lightBlue,
                    color: Colors.lightBlue,
                    tabs: [
                      GButton(
                        icon: Icons.compare_arrows,
                        text: 'Pointing',
                        textStyle: TextStyle(fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      GButton(
                        icon: Icons.map,
                        text: 'Maps',
                        textStyle: TextStyle(fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Setting',
                        textStyle: TextStyle(fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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



