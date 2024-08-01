import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'login.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController search = TextEditingController();
  String locationMessage = "Tap on Button to get current location";
  late String lat;
  late String long;
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Services disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error("permission denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Permission denied forever");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      setState(() {
        locationMessage = 'Latitude :$lat ,\n Longitude :$long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(url)
        ? await launchUrlString(url)
        : throw "Could not launch $url";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Center(
                child: Text(
              "Flutter User Location",
            )),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: search,
                    decoration: InputDecoration(
                        hintText: 'Search here..',
                        icon: Icon(Icons.location_on)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: Colors.greenAccent,
                    child: SizedBox(
                      height: 100,
                      width: 300,
                      child: Center(
                        child: Text(
                          locationMessage,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          _getCurrentPosition().then((value) {
                            lat = '${value.latitude}';
                            long = '${value.longitude}';
                            setState(() {
                              locationMessage =
                                  'Latitude :$lat ,\n Longitude :$long';
                            });
                            _liveLocation();
                          });
                        },
                        child: Text("Get current location of user")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _openMap(lat, long);
                      },
                      child: Text("Open Google Map"))
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Text("Authenticate")),
                ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    title: Text("Sign IN"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
