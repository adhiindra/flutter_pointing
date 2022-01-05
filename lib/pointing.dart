import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';
import 'package:shared_preferences/shared_preferences.dart';



class pointing extends StatefulWidget {

  @override
  _pointingState createState() => _pointingState();
}

class _pointingState extends State<pointing> {

  String user = "Perangkat";
  final ref = FirebaseDatabase.instance.ref('Device/');
  late StreamSubscription streamRef;

  bool isSwitch = false;
  int vBts = 0;
  int hBts = 0;
  int vClient = 0;
  int hClient = 0;
  double altitudeBts = 0.0;
  double altitudeClient = 0.0;
  double sldValueDerajat = 10;
  int valueDerajat = 10;
  var colorBts = Colors.lightBlue.shade700;
  var colorClient = Colors.grey.shade50;
  bool loadingData = true;

  @override
    void initState() {
    getPrefData();
    super.initState();

  }

  void getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('username')!;
      print(user);
    });
    readData();
  }

  void updateDataBTS() async{
    await ref.child('$user/Derajat/BTS/').update({
      "Vertical":vBts,
      "Horizontal":hBts,
    });
  }

  void updateDataClient() async{
    await ref.child('$user/Derajat/Client/').update({
      "Vertical":vClient,
      "Horizontal":hClient,
    });
  }

  readData() async{
    streamRef = ref.child('$user/GPS/BTS/Altitude').onValue.listen((event) {
      final double sAlt = double.parse(event.snapshot.value.toString());
      setState(() {
        altitudeBts = sAlt;
      });
    });

    streamRef = ref.child('$user/GPS/Client/Altitude').onValue.listen((event) {
      final double sAltClient = double.parse(event.snapshot.value.toString());
      setState(() {
        altitudeClient = sAltClient;
      });
    });

    streamRef = ref.child('$user/Derajat/BTS/Vertical').onValue.listen((event) {
      final int svBts = int.parse(event.snapshot.value.toString());
      setState(() {
        vBts = svBts;
      });
    });

    streamRef = ref.child('$user/Derajat/BTS/Horizontal').onValue.listen((event) {
      final int shBts = int.parse(event.snapshot.value.toString());
      setState(() {
        hBts = shBts;
      });
    });
    //
    streamRef = ref.child('$user/Derajat/Client/Vertical').onValue.listen((event) {
      final int svClient = int.parse(event.snapshot.value.toString());
      setState(() {
        vClient = svClient;
      });
    });

    streamRef = ref.child('$user/Derajat/Client/Horizontal').onValue.listen((event) {
      final int shClient = int.parse(event.snapshot.value.toString());
      setState(() {
        hClient = shClient;
      });
    });

    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loadingData = false;
      });
    });
  }

  Widget derajatClient(){
    var index;
    if(loadingData){
      index = SizedBox(
        width: 200,
        child: PlaceholderLines(
          count: 3,
          animate: true,
          align: TextAlign.left,
        ),
      );
    }else{
      index = Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                  'Vertical : '
              ),
              Text("$vClient"),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                  'Horizontal : '
              ),
              Text("$hClient"),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Altitude : '
              ),
              Text("$altitudeClient"),
              Text('m'),
            ],
          ),
        ],
      );
    }
    return index;
  }

  Widget derajatBTS(){
    var index;
    if(loadingData){
      index = SizedBox(
        width: 200,
        child: PlaceholderLines(
          count: 3,
          animate: true,
          align: TextAlign.left,
        ),
      );
    }else{
      index = Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                  'Vertical : '
              ),
              Text("$vBts"),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                  'Horizontal : '
              ),
              Text("$hBts"),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Altitude : '
              ),
              Text("$altitudeBts"),
              Text('m'),
            ],
          ),
        ],
      );
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/ 1.38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: 150,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          HapticFeedback.lightImpact();
                          isSwitch = false;
                          colorBts = Colors.lightBlue.shade700;
                          colorClient = Colors.grey.shade50;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorBts,
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Derajat BTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                                ),
                              ),
                              SizedBox(height: 4,),

                              derajatBTS(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: 150,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          HapticFeedback.lightImpact();
                          isSwitch = true;
                          colorBts = Colors.grey.shade50;
                          colorClient = Colors.lightBlue.shade700;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorClient,
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Derajat Client',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4,),

                              derajatClient(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: <Widget>[
                Transform.rotate(
                  angle: 4.7,
                  child: IconButton(
                    iconSize: 70,
                    onPressed: (){
                      if(isSwitch){
                        if(vClient != 180){
                          setState(() {
                            vClient = vClient + valueDerajat;
                            if(vClient >= 180){
                              vClient = 180;
                            }
                          });
                          updateDataClient();
                        }
                      }else{
                        if(vBts != 180){
                          setState(() {
                            vBts = vBts + valueDerajat;
                            if(vBts >= 180){
                              vBts = 180;
                            }
                          });
                          updateDataBTS();
                        }
                      }
                    },
                    icon: Icon(Icons.double_arrow,color: Colors.lightBlue,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Transform.rotate(
                      angle: 180 * math.pi / 180,
                      child: IconButton(
                        iconSize: 70,
                        onPressed: (){
                          if(isSwitch){
                            if(hClient != 180){
                              setState(() {
                                hClient = hClient + valueDerajat;
                                if(hClient >= 180){
                                  hClient = 180;
                                }
                              });
                              updateDataClient();
                            }
                          }else{
                            if(hBts != 180){
                              setState(() {
                                hBts = hBts + valueDerajat;
                                if(hBts >= 180){
                                  hBts = 180;
                                }
                              });
                              updateDataBTS();
                            }
                          }
                        },
                        icon: Icon(Icons.double_arrow,color: Colors.lightBlue,),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(70, 70), // button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.lightBlue, // button color
                          child: InkWell(
                            splashColor: Colors.white, // splash color
                            onTap: () {
                              if(isSwitch){
                                setState(() {
                                  vClient = 90;
                                  hClient = 90;
                                });
                                updateDataClient();
                              }else{
                                setState(() {
                                  vBts = 90;
                                  hBts = 90;
                                });
                                updateDataBTS();
                              }
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[ // icon
                                Text("RESET",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        iconSize: 70,
                        onPressed: (){
                          if(isSwitch){
                            if(hClient != 0){
                              setState(() {
                                hClient = hClient - valueDerajat;
                                if(hClient <= 0){
                                  hClient = 0;
                                }
                              });
                              updateDataClient();
                            }
                          }else{
                            if(hBts != 0){
                              setState(() {
                                hBts = hBts - valueDerajat;
                                if(hBts <= 0){
                                  hBts = 0;
                                }
                              });
                              updateDataBTS();
                            }
                          }
                        },
                        icon: Icon(Icons.double_arrow, color: Colors.lightBlue,)
                    ),

                  ],
                ),
                Transform.rotate(
                  angle: 90 * math.pi / 180,
                  child: IconButton(
                    iconSize: 70,
                    onPressed: (){
                      if(isSwitch){
                        if(vClient != 0){
                          setState(() {
                            vClient = vClient - valueDerajat;
                            if(vClient <= 0){
                              vClient = 0;
                            }
                          });
                          updateDataClient();
                        }
                      }else{
                        if(vBts != 0){
                          setState(() {
                            vBts = vBts - valueDerajat;
                            if(vBts <= 0){
                              vBts = 0;
                            }
                          });
                          updateDataBTS();
                        }
                      }
                    },
                    icon: Icon(Icons.double_arrow,color: Colors.lightBlue,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width /1.1 ,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                        child: Text(
                          "SPEED SLIDER",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Slider(
                      value: sldValueDerajat,
                      max: 60,
                      min: 1,
                      activeColor: Colors.lightBlue,
                      divisions: 20,
                      label: sldValueDerajat.round().toString(),
                      onChanged: (double value){
                        setState(() {
                          sldValueDerajat = value;
                          valueDerajat = sldValueDerajat.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}