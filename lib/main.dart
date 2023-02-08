import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //Test contribution Fares
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MapApp(),

      );
    
  }
}

class MapApp extends StatefulWidget {

  @override
  _MapAppState createState()=> _MapAppState();
}

class _MapAppState extends State<MapApp> {
  double long = 49.5;
  double lat = -0.09;
  LatLng point = LatLng(48.858370, 2.294481);
  var location = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          FlutterMap(
            options: MapOptions(
              onTap: (p) {
                setState(() {
                  point=p;
                });
              },
              center: LatLng(48.858370,2.294481),
              zoom: 17.0
          ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: [
                Marker(
                  width: 100.0,
                  height: 100.0,
                  point:
                    point,
                  builder: (ctx)=> Icon(
                    Icons.location_on,
                    color: Colors.red,
                  )
                )
              ])
            ],
          )
        ]
    );
  }
}

