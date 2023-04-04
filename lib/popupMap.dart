import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PopupMap extends StatefulWidget {
  const PopupMap({Key? key}) : super(key: key);
  @override
  State<PopupMap> createState() => _PopupMapState();
}

class _PopupMapState extends State<PopupMap> {
  List<DocumentSnapshot> documents = [];
  List<LatLng> coordinates = [];
  List<bool> me = [];
  List<Marker> markers = [];
   List<String> _selectedKeywords = [];
  final List<String> _keywords = [
    'Vêtements',
    'Vêtements pour enfants',
    'Musique',
    'Jeux vidéos',
    'Antiquités',
    'Cinéma',
    'Livres',
    'Manga',
    'Objets de collection',
    'Jeux',
    'Art',
    'Autre'
  ];

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
          .asMap()
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
            color: me[index]==true?const Color(0xFF885F06):const Color(0xFFE19F0C),
          ),
        ),
      )))
          .values
          .toList();
    });
  }

  void _filterMarkers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('spot').get();

    setState(()  {
      // Filter documents based on keyword search
      documents = snapshot.docs.where((doc) => (doc['mot-cles'] as List<dynamic>).any((keyword) => _selectedKeywords.contains(keyword))).toList();
      coordinates = documents.map((doc) => LatLng(doc['latitude'], doc['longitude'])).toList();
      me = documents.map((doc) => FirebaseAuth.instance.currentUser?.uid == doc['userid']).toList();

      // Update markers based on filtered documents
      markers = coordinates
          .asMap()
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
            color: me[index] == true ? const Color(0xFF63AEEE) : const Color(
                0xFF807E7A),
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
      appBar: AppBar(
        title: const Text('Rechercher un stand par thème'),
        backgroundColor: const Color(0xFFE19F0C),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mots-clés',
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _keywords.map((String keyword) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(keyword),
                        selected: _selectedKeywords.contains(keyword),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedKeywords.add(keyword);
                            } else {
                              _selectedKeywords.remove(keyword);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedKeywords=[];
                    loadDocuments();
                  });
                },
                child: Text('Annuler la recherche'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFB71118)),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  if(_selectedKeywords.isNotEmpty) {
                    _filterMarkers();
                  }
                },
                child: Text('Rechercher'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF2487DC)),
                ),
              ),
            ],
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(50.640930,3.044581),
                zoom:14,
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
          ),
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
                      return const CircularProgressIndicator();
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




