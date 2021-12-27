import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';



class pointing extends StatefulWidget {

  @override
  _pointingState createState() => _pointingState();
}

class _pointingState extends State<pointing> {

  String user = "Device 4";
  final ref = FirebaseDatabase.instance.ref('Device/');
  late StreamSubscription streamRef;

  bool isSwitch = false;
  int vBts = 0;
  int hBts = 0;
  int vClient = 0;
  int hClient = 0;

  @override
    void initState() {
    readData();
    super.initState();

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


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                width: 130,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Derajat BTS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4,),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Switch(
              value: isSwitch,
              onChanged: (value) {
                setState(() {
                  isSwitch = value;
                  if (isSwitch){
                    print("Client");
                  }else{
                    print('BTS');
                  }
                });
              },
              activeTrackColor: Colors.grey,
              activeColor: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                width: 130,
                child: Card(
                  clipBehavior: Clip.antiAlias,
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
                        Row(
                          children: <Widget>[
                            Text(
                                'Vertical : '
                            ),
                            Text('$vClient'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                                'Horizontal : '
                            ),
                            Text('$hClient'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
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
                            vClient = vClient + 10;
                          });
                          updateDataClient();
                        }
                      }else{
                        if(vBts != 180){
                          setState(() {
                            vBts = vBts + 10;
                          });
                          updateDataBTS();
                        }
                      }
                    },
                    icon: Icon(Icons.double_arrow,color: Colors.lightBlueAccent,),
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
                                hClient = hClient + 10;
                              });
                              updateDataClient();
                            }
                          }else{
                            if(hBts != 180){
                              setState(() {
                                hBts = hBts + 10;
                              });
                              updateDataBTS();
                            }
                          }
                        },
                        icon: Icon(Icons.double_arrow,color: Colors.lightBlueAccent,),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(70, 70), // button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.lightBlueAccent, // button color
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
                                hClient = hClient - 10;
                              });
                              updateDataClient();
                            }
                          }else{
                            if(hBts != 0){
                              setState(() {
                                hBts = hBts - 10;
                              });
                              updateDataBTS();
                            }
                          }
                        },
                        icon: Icon(Icons.double_arrow, color: Colors.lightBlueAccent,)
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
                            vClient = vClient - 10;
                          });
                          updateDataClient();
                        }
                      }else{
                        if(vBts != 0){
                          setState(() {
                            vBts = vBts - 10;
                          });
                          updateDataBTS();
                        }
                      }
                    },
                    icon: Icon(Icons.double_arrow,color: Colors.lightBlueAccent,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}