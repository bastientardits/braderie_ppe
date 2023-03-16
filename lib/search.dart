import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';


class searchStand extends StatefulWidget {
  const searchStand({Key? key}) : super(key: key);

  @override
  State<searchStand> createState() => _searchStandState();
}

class _searchStandState extends State<searchStand> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _keywords = [
    'Vêtements',
    'Vêtements pour enfants',
    'Musique',
    'Antiquités',
    'Cinéma',
    'Livres',
    'Manga',
    'Objets de collection',
    'Jeux',
    'Jouets',
    'Jeux vidéos'
  ];
  List<String> _selectedKeywords = [];
  String? _selectedKeyword;
  List<File> _images = [];
  String _description = "";

  Future<void> _pickImage(ImageSource source) async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images.addAll(
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String description = _description;
      String keywords = _selectedKeyword ?? '';
      List<String> keywordsList = _selectedKeywords;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (_images.isNotEmpty)
                Column(
                  children: _images.asMap().entries.map((entry) {
                    final index = entry.key;
                    final image = entry.value;
                    return Stack(
                      children: <Widget>[
                        Image.file(
                          image,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () => _removeImage(index),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              SizedBox(height: 32.0),
              SizedBox(height: 16.0),
              InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mots-clés',
                ),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _keywords.map((String keyword) {
                    return ChoiceChip(
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
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear the form when "Annuler" is pressed.
                        _formKey.currentState!.reset();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text('Annuler'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Profil'),
                                backgroundColor: Color(0xFFE19F0C),
                              ),
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('stand')
                                          .where('mot-cles',arrayContainsAny:_selectedKeywords )
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                3 /
                                                4,
                                            child: ListView(
                                                children: snapshot.data!.docs
                                                    .map((snap) {
                                              return Card(
                                                  child: ListTile(
                                                title: Text(
                                                    snap['address'].toString()),
                                                subtitle: Text(snap['description']
                                                    .toString()+" "+snap['mot-cles']
                                                    .toString()
                                                ),
                                                    trailing: InkWell(
                                                      child: Icon(Icons.gps_fixed_outlined),
                                                      onTap: () {
                                                        String latlong = "${snap['latitude']},${snap['longitude']}";
                                                        String url = "https://maps.google.com/?q=${snap['latitude']},${snap['longitude']}";
                                                        final Uri _url = Uri.parse(url);
                                                        launchUrl(_url);
                                                      },
                                                    ),
                                              ));
                                            }).toList()));
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Retour"),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(const Color(0xFFE19F0C)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text("Rechercher"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFFE19F0C)),
                        ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
