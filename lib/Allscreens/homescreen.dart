// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpcar/Assistants/assistantmethods.dart';
import 'package:helpcar/DataHandler/appData.dart';
import 'package:helpcar/HelperScreens/homepage.dart';
import 'package:provider/provider.dart';

import '../searchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String idScreen = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: prefer_final_fields, unused_field
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late LatLng _center = LatLng(0, 0);

  // ignore: prefer_final_fields
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
// ignore: todo
// TODO: Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
// ignore: todo
// TODO: Handle denied permission forever
    } else {
// Permission granted
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });

    Position position = Position(
      latitude: _center.latitude,
      longitude: _center.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      floor: null,
      isMocked: false,
    );

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address :: $address");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("HelpCAR"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(children: [
                    Image.asset("images/user_icon.png",
                        height: 65.0, width: 65.0),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Profile Name",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Brand Bold"),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text("Visit Profile"),
                      ],
                    )
                  ]),
                ),
              ),
              Divider(),
              SizedBox(
                height: 12.0,
              ),
              ListTile(
                leading: Icon(Icons.person,color: Colors.blue),
                title: Text(
                  "Visit Profile",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.history,color: Colors.blue),
                title: Text(
                  "History",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              GestureDetector(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => helperHomePage()));
                },
                child: ListTile(
                  leading: Icon(Icons.car_rental,color: Colors.blue),
                  title: Text(
                    "Provide Help",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ignore: unnecessary_null_comparison
      body: _center == LatLng(0, 0)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  myLocationEnabled: true,
                ),

                //Drawer Button
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5.0,
                  left: 5.0,
                  child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height:250.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 228, 199),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 16.0,
                            spreadRadius: 0.5,
                            offset: const Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:10.0),
                              Text(
                                "Hi there",
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                "Need Help?",
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "Brand Bold"),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 4.0,
                                          spreadRadius: 0.5,
                                          offset: const Offset(0.7, 0.7),
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text("Search Destination"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Builder(builder: (context) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 265,
                                          child: Text(
                                            //_currentAddress,
                                            Provider.of<AppData>(context).userPickUpLocation!=null?Provider.of<AppData>(context).userPickUpLocation!.placeName:"Your Location",
                                            textAlign: TextAlign
                                                .left, // Set text alignment
                                            softWrap: true,
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Text(
                                          "Your Current Location",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ],
                          )),
                    ))
              ],
            ),
    );
  }
}