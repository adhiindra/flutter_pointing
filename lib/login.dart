import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("LOGIN",style: TextStyle(
                  fontFamily: ('Roboto'),
                  color: Colors.white,
                  fontSize: 20,
                ),),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
