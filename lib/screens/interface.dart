// ignore_for_file: file_names, prefer_typing_uninitialized_variables, avoid_print, unused_element, prefer_collection_literals, prefer_final_fields, prefer_const_constructors
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rassurant/screens/pulsation.dart';
import 'package:rassurant/screens/signin_screen.dart';
import 'package:rassurant/utils/color_utils.dart';
import 'package:location/location.dart';

class inter extends StatefulWidget {
  const inter({Key? key}) : super(key: key);

  @override
  _interState createState() => _interState();
}

class _interState extends State<inter> {
  late GoogleMapController mapController;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  final Set<Marker> markers = {}; // For holding instance of Marker
  //! firestore marker bin/
  var marker = <Marker>[];
  Set<Marker> _markers = {};
  late BitmapDescriptor pinLocationIcon;

  late BitmapDescriptor customIcon;

  get currentLocation => null;

// make sure to initialize before map loading
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final Uint8List markerIcon1 =
        await getBytesFromAsset('assets/images/chaise.png', 250);

    _controllerGoogleMap.complete(controller);
    newGoogleMapController = controller;
    await FirebaseFirestore.instance
        .collection("localisation")
        .snapshots()
        .listen((event) async {
      //_markers={};
      setState(() {
        bottomPaddingOfMap = 240;

        for (var doc in event.docs) {
          _markers.add(
            Marker(
                markerId: MarkerId(doc.id),
                position:
                    LatLng(doc.data()["Latitude"], doc.data()["Longitude"]),
                infoWindow: InfoWindow(
                  title: "Je suis là !",
                  snippet:
                      "pulsation  ${doc.data()["pulsation"]}  ",
                ),
                icon: BitmapDescriptor.fromBytes(markerIcon1)),
          );
        }
      });
    });
    setState(() {});
    locateUserPosition();
  }
  //! firestore marker bin/

  final Set<Marker> _marker = Set<Marker>();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
//////!
  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await geolocator.Geolocator.requestPermission();

    if (_locationPermission == geolocator.LocationPermission.denied) {
      _locationPermission = await geolocator.Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    geolocator.Position cPosition =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  late Location location;
  Completer<GoogleMapController> _controller = Completer();

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: const MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  void initState() {
    setState(() {});
    checkIfLocationPermissionAllowed();
    super.initState();
    location = Location();
    // getJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
     appBar: AppBar(
       flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
        ),
        title: const Text(
          "Rassurant",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 20,
        actions: [
           IconButton(icon : Icon(Icons.health_and_safety),
           onPressed: () {
           FirebaseAuth.instance.signOut().then((value) {
              print("pulsation"); 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pulsation()));
            });
          },

          ),
          IconButton(icon : Icon(Icons.logout),
           onPressed: () {
           FirebaseAuth.instance.signOut().then((value) {
              print("Sortir"); 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },

          ),
        ],
        
      ),
      body: Stack(
        children: [
          GoogleMap(
            //padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            onMapCreated: _onMapCreated,
            markers: _markers,
            mapType: MapType.normal,
            myLocationEnabled: true,
            // zoomGesturesEnabled: true,
            // zoomControlsEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(35.506798, 11.046753),
              zoom: 250,
            ),
          ),
        

          //custom hamburger button for drawer
        ],
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}