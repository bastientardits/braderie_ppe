import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_storage/firebase_storage.dart';

class popupMap extends StatefulWidget {
  const popupMap({Key? key}) : super(key: key);
  @override
  State<popupMap> createState() => _popupMapState();
}

class _popupMapState extends State<popupMap> {
  List<DocumentSnapshot> documents = [];
  List<LatLng> coordinates = [];
  List<bool> me = [];
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
        if(FirebaseAuth.instance.currentUser?.uid==document['userid'])
        {
          me.add(true);
        }
        else
        {
          me.add(false);
        }
        coordinates.add(l);
      }

      markers=coordinates
          .asMap() // Ajout de la méthode asMap() pour obtenir l'index
          .map((index, point) => MapEntry(index, Marker(
        point: point,
        width: 60,
        height: 60,
        builder: (context) => GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Popup(
                document: documents[index],
              ),
            );
          },
          child: Icon(
            Icons.location_pin,
            size: 60,
            color: me[index]==true?Color(0xFF885F06):Color(0xFFE19F0C),
          ),
        ),
      )))
          .values
          .toList();
    });
  }

  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(50.6371, 3.0530),
          zoom:17,

        ),
        mapController: mapController,
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: markers),
        ],


      ),
    );
  }
}

class Popup extends StatelessWidget {
  final DocumentSnapshot document;
  FirebaseStorage storage = FirebaseStorage.instance;
  Popup({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    List<dynamic> pictures = document["pictures"];
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(document['description'].toString()),
          Text(document['mot-cles'].toString()),
          Text(document['address'].toString()),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pictures.length,
              itemBuilder: (BuildContext context, int index) {
                String doc = pictures[index];
                return FutureBuilder(
                  future: storage.ref().child(doc).getDownloadURL(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (kDebugMode) {
                      print(snapshot.data.toString());
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(snapshot.data.toString(),
                          height: 100, width: 100),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




