import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
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
  final List<String> _selectedKeywords = [];
  String? _selectedKeyword;
  final List<File> _images = [];

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher un stand par thème'),
        backgroundColor: const Color(0xFFE19F0C),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
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
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => _removeImage(index),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 32.0),
                const SizedBox(height: 16.0),
                InputDecorator(
                  decoration: const InputDecoration(
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
                  const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text('Profil'),
                                  backgroundColor: const Color(0xFFE19F0C),
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
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          return SizedBox(
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
                                                  subtitle: Text("${snap['description']} ${snap['mot-cles']}"
                                                  ),
                                                      trailing: InkWell(
                                                        child: const Icon(Icons.gps_fixed_outlined),
                                                        onTap: () {
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
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(const Color(0xFFE19F0C)),
                                        ),
                                        child: const Text("Retour"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFFE19F0C)),
                          ),
                        child: const Text("Rechercher"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
