import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 500;
  double _panelHeightClosed = 150;
  double panelmultiplied = .60;
  String username = "";
  String password = "";
  bool valUser = false;
  bool valPass = false;
  String validasiUser = "";
  String validasiPass = "";

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * panelmultiplied;

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            collapsed: _collapse(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(58.0),
                topRight: Radius.circular(58.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
              panel(pos);
            }),
          ),

          Positioned(
              top: 0,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent,
                      )))),
          //the SlidingUpPanel Title
        ],
      ),
    );
  }

  void panel(double x){
    if(x == 0.0){
      panelmultiplied = .60;
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Widget _collapse(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
            Image.asset('assets/Firebase_Logo.png',width: 200,),
            Text("Slide Up Login",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue
              ),
            )
          ],
        ),
    ),

    );
  }
  Widget _panel(ScrollController sc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("APLIKASI POINTING",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        fontSize: 20,
                        color: Colors.lightBlue
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Container(
                  width: 270,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Theme(
                          data: ThemeData(
                            hintColor: Colors.lightBlue
                          ),
                          child: TextField(
                            onChanged: (text){
                              setState(() {
                                username = text;
                              });
                            },
                            onTap: (){
                              setState(() {
                                panelmultiplied = .80;
                              });
                            },
                            onSubmitted: (value){
                              setState(() {
                                panelmultiplied = .60;
                              });
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                errorText: valUser? validasiUser : null,
                                labelStyle: TextStyle(color: Colors.lightBlue,
                                    fontFamily:"Montserrat"),
                                labelText: "Username",
                                hintStyle: TextStyle(color: Colors.lightBlue,
                                    fontFamily:"Montserrat"),
                                hintText: "Masukan Username",
                                fillColor: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: const Offset(3, 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        child: Theme(
                          data: ThemeData(
                            hintColor: Colors.lightBlue
                          ),
                          child: TextField(
                            onChanged: (text){
                              setState(() {
                                password = text;
                              });
                            },
                            onTap: (){
                              setState(() {
                                panelmultiplied = .80;
                              });
                            },
                            onSubmitted: (value){
                              setState(() {
                                panelmultiplied = .60;
                              });
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                errorText: valPass? validasiPass : null,
                                labelStyle: TextStyle(color: Colors.lightBlue,
                                    fontFamily:"Montserrat" ),
                                labelText: "Password",
                                hintStyle: TextStyle(color: Colors.lightBlue,
                                    fontFamily:"Montserrat"),
                                hintText: "Masukan Password",
                                fillColor: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: const Offset(3, 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      RoundedLoadingButton(
                        color: Colors.lightBlue,
                        successColor: Colors.lightGreen,
                        controller: _btnController,
                        onPressed: () => Login(),
                        valueColor: Colors.white,
                        borderRadius: 15,
                        height: 43,
                        resetDuration: Duration(seconds: 2),
                        resetAfterDuration: true,
                        child: Text('LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                              fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height / 50),
            child: Column(
              children: <Widget>[
                Text("Powered By :",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/Firebase_Logo.png',width: MediaQuery.of(context).size.height / 7,),
                    Image.asset('assets/Google-flutter-logo.png',width: MediaQuery.of(context).size.height / 9,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

    );

  }

  void Login(){
    setState(() {
      valUser = false;
      valPass = false;
      HapticFeedback.lightImpact();
      print('$username, $password');
      if(username != ""){
        if(password != ""){
          cekUser();
        }else{
          setState(() {
            valPass = true;
            _btnController.error();
            validasiPass = "Password Tidak Boleh Kosong";
          });
        }
      }else{
        setState(() {
          valUser = true;
          _btnController.error();
          validasiUser = "Username Tidak Boleh Kosong";
        });
      }
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => home()));
    });
  }

  void cekUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance.ref('Device/'); 
    ref.orderByChild("devicename").equalTo(username).once().then((value) async {
      print(value.snapshot.value.toString());
      if(value.snapshot.value == null){
        setState(() {
          valUser = true;
          _btnController.error();
          validasiUser = "Username Tidak Ditemukan";
        });
        print("username tidak ditemukan");
      }else{
        for(DataSnapshot snap in value.snapshot.children){
          String dbPassword = snap.child('password').value.toString();
          print(dbPassword);
          if(dbPassword == password){
            print(snap.key.toString()); // childkey
            await prefs.setString('username', snap.key.toString());
            var _ambiltext = prefs.getString('username');
            print('sharepref $_ambiltext');
            setState(() {
              _btnController.success();
              Future.delayed(const Duration(seconds: 1),(){
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              });
            });
          }else{
            setState(() {
              valPass = true;
              _btnController.error();
              validasiPass = "Password Salah";
            });
            print("password salah");
          }
        }
      }
    });
  }

  Widget _body() {
    return Container(
        color: Colors.lightBlue,
      child:
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Center(
          child: Icon(
            Icons.settings_input_antenna,
            size: 80,
            color: Colors.white,
          )
        ),
      ),
    );
  }


}
