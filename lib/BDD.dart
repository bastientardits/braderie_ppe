import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';


class BDD extends StatefulWidget {
  const BDD({Key? key}) : super(key: key);

  @override
  State<BDD> createState() => _BDDState();
}

class _BDDState extends State<BDD> {
  List<DocumentSnapshot> documents = [];
  List<LatLng> coordinates = [];
  List<Marker> markers = [];
  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  void loadDocuments() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('stand').get();
    setState(() {
      documents = snapshot.docs;
      for(var document in documents){
        LatLng l = LatLng(document['latitude'], document['longitude']);
        coordinates.add(l);
      }
      markers=coordinates 
        .map((l) => Marker(
        point: l,
        width: 60,
        height: 60,
        builder: (context) => Icon(
          Icons.pin_drop,
          size: 60,
          color: Colors.blueAccent,
        ),
      ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FlutterMap(
        options: MapOptions(
                    center: LatLng(50.6371, 3.0530),
        ),


        
      ),
    );
  }
}
