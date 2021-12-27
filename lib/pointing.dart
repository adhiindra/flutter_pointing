import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';



class pointing extends StatefulWidget {

  @override
  _pointingState createState() => _pointingState();
}

class _pointingState extends State<pointing> {

  final ref = FirebaseDatabase.instance.ref();
  late StreamSubscription streamRef;

  bool isSwitch = false;
  var vBts = "0";
  var hBts = "0";
  var vClient = "0";
  var hClient = "0";

  @override
    void initState() {
    readData();
    super.initState();

  }
  readData() async{
    streamRef = ref.child('Device/Device 4/Derajat/BTS/Vertical').onValue.listen((event) {
      final String? svBts = event.snapshot.value.toString();
      setState(() {
        vBts = '$svBts';
      });
    });

    streamRef = ref.child('Device/Device 4/Derajat/BTS/Horizontal').onValue.listen((event) {
      final String? shBts = event.snapshot.value.toString();
      setState(() {
        hBts = '$shBts';
      });
    });

    streamRef = ref.child('Device/Device 4/Derajat/Client/Vertical').onValue.listen((event) {
      final String? svClient = event.snapshot.value.toString();
      setState(() {
        vClient = '$svClient';
      });
    });

    streamRef = ref.child('Device/Device 4/Derajat/Client/Horizontal').onValue.listen((event) {
      final String? shClient = event.snapshot.value.toString();
      setState(() {
        hClient = '$shClient';
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
                            onTap: () {}, // button pressed
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
                        onPressed: (){},
                        icon: Icon(Icons.double_arrow, color: Colors.lightBlueAccent,)
                    ),

                  ],
                ),
                Transform.rotate(
                  angle: 90 * math.pi / 180,
                  child: IconButton(
                    iconSize: 70,
                    onPressed: (){
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