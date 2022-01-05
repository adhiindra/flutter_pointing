import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class maps extends StatefulWidget {
  const maps({Key? key}) : super(key: key);

  @override
  _mapsState createState() => _mapsState();
}

class _mapsState extends State<maps> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng mylocation;
  late CameraPosition _myPosition;

  String user = "Perangkat";
  final ref = FirebaseDatabase.instance.ref('Device/');
  late StreamSubscription streamRef;

   late LatLng latLngBts;
   late LatLng latLngClient;

  List<Marker> _markers = <Marker>[];
  Set<Polyline>_polyline={};
  List<LatLng> latlng = <LatLng>[];
  late LatLngBounds latLngBounds;
  late LocationData locationData;

  bool gpsLoading = false;


  @override
  void initState() {
    super.initState();
    getPrefData();
  }


  void getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('username')!;
      print(user);
    });
    readData();
  }

  void _getUserLocation() async {
    Location location = new Location();
    locationData = await location.getLocation();
    double? lat = locationData.latitude;
    double? long = locationData.longitude;

     _myPosition = CameraPosition(
      target: LatLng(lat!, long!),zoom: 20
    );

     setState(() {
       gpsLoading = false;
     });
     print("Locations");
    _goToRealPosition();

  }
  

  readData() async{
    streamRef = ref.child('$user/GPS/').onValue.listen((event) {
      final double datLatBTS = double.parse(event.snapshot.child('BTS/Latitude').value.toString());
      final double datLongBTS = double.parse(event.snapshot.child('BTS/Longitude').value.toString());
      final double datLatClient = double.parse(event.snapshot.child('Client/Latitude').value.toString());
      final double datLongClient = double.parse(event.snapshot.child('Client/Longitude').value.toString());
      const String datSnap = "BTS";
      const String datSnapClient = "Client";
      setState(() {
        latLngBts = LatLng(datLatBTS,datLongBTS);
        latLngClient = LatLng(datLatClient, datLongClient);
        latlng.add(latLngBts);
        latlng.add(latLngClient);
        _markers.add(
            Marker(
                markerId: MarkerId(datSnap),
                position: LatLng(datLatBTS,datLongBTS),
                infoWindow: InfoWindow(
                    title: datSnap
                ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            )
        );

        _markers.add(
            Marker(
                markerId: MarkerId(datSnapClient),
                position: LatLng(datLatClient,datLongClient),
                infoWindow: InfoWindow(
                    title: datSnapClient
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
            )
        );

        if(latLngBts.latitude > latLngClient.latitude ){
          latLngBounds = LatLngBounds(southwest: latLngClient, northeast: latLngBts);
        }else{
          latLngBounds = LatLngBounds(southwest: latLngBts, northeast: latLngClient);
        }

        _polyline.add(Polyline(
            polylineId: PolylineId("1"),
            visible: true,
            //latlng is List<LatLng>
            points: latlng,
            color: Colors.blue,
            width: 5
        ));
        _goToMyPosition();
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(0,0),zoom: 15
            ),
            markers: Set<Marker>.of(_markers),
            polylines: _polyline,
            onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            },myLocationEnabled: true, myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 25, 10),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70)
                    ) ,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(70),
                      onTap: (){
                        setState(() {
                          HapticFeedback.lightImpact();
                          _goToMyPosition();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(13),
                          child: Icon(
                              Icons.settings_input_antenna,
                            size: 30,color: Colors.lightBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 25, 40),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70)
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(70),
                      onTap: (){
                        setState(() {
                          HapticFeedback.lightImpact();
                          gpsLoading = true;
                          _getUserLocation();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(13),
                          child: gpsLoading? CircleprogresBar() : gpsIcon(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget CircleprogresBar(){
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(),
    );
  }
  Widget gpsIcon(){
    return Icon(
      Icons.my_location, size: 30, color: Colors.lightBlue,
    );
  }

  Future<void> _goToMyPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 60));
  }

  Future<void> _goToRealPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }
}
