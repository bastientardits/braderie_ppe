import 'dart:io' ;
import 'dart:html'hide File ;
import 'osmhome.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:path/path.dart';



class Profil extends StatefulWidget {
  FirebaseStorage storage = FirebaseStorage.instance;
  Profil({Key? key}) : super(key: key);
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  List<dynamic> pictures = [];
  late String? _description;
  bool _isLoggedIn = false;
  double pickedLongitude = 0.1;
  double pickedLatitude = 0.1;
  late DocumentSnapshot document;
  List<File> _images = [];


  void _addImage(String id) async {
    String imageUrl = "";

    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images.addAll(pickedImages.map((pickedImage) => File(pickedImage.path)).toList());
      });
      for (File _image in _images) {
        String fileName = basename(_image.path);
        String res = "${FirebaseAuth.instance.currentUser!.uid}/$fileName";
        print("------------------------------------------------------");
        print(res);
        print("------------------------------------------------------");
        pictures.add(res);

        Reference reference = FirebaseStorage.instance.ref().child(res);
        UploadTask uploadTask = reference.putFile(_image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await reference.getDownloadURL();

        setState(() {
          // print("picture uploaded");
        });
      }
      FirebaseFirestore.instance.collection('stand').doc(id).update(
          {"pictures": pictures});
    }
  }

  Future<void> deleteImage(int index, String id) async {
    String doc = pictures[index];
    try {
      await FirebaseStorage.instance.ref().child(doc).delete();
      // Remove the deleted image from the UI
      setState(() {
        pictures.removeAt(index);
      });
    } catch (e) {
      print("Error deleting image: $e");
    }
    FirebaseFirestore.instance.collection('stand').doc(id).update(
        {"pictures": pictures});
  }


  void _showEditForm(BuildContext context, String id) async {
    String? description;
    String locationaddress = 'Replacer le stand';
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
    List<String> _selectedKeywords = [];

    // retrieve the document from Firebase

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(
        'stand').doc(id).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    String defaultDescription = data?['description'] ?? 'Default Description';
    _selectedKeywords = List<String>.from(data?['mot-cles']);
    _description = data?['description'];
    setState(() {
      pictures = data?['pictures'];
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier un stand'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addImage(id),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                initialValue: _description,
                onChanged: (String value) {
                  setState(() {
                    description = value;
                  });
                },
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Insérez une nouvelle description';
                  }
                  return null;
                },
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Container(
                        child: ElevatedButton(
                            child: Text(locationaddress),
                            onPressed: () {
                              _showModal(context);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    children: pictures.map((doc) =>
                        FutureBuilder(future: widget.storage.ref()
                            .child(doc)
                            .getDownloadURL(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            int index = pictures.indexOf(
                                doc); // Récupère l'index de l'élément dans pictures
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.network(snapshot.data.toString(),
                                      height: 100, width: 100),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          deleteImage(index, id).then((_) {
                                            setState(() {
                                              pictures.removeAt(index);
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                //edit the stand
                description ??= data?['description'];

                if (pickedLongitude == 0.1) {
                  FirebaseFirestore.instance
                      .collection('stand')
                      .doc(id)
                      .update({
                    'description': description,
                    'mot-cles': _selectedKeywords
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('stand')
                      .doc(id)
                      .update({
                    'description': description,
                    'mot-cles': _selectedKeywords,
                    'longitude': pickedLongitude,
                    'latitude': pickedLatitude
                  });
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('stand modifié')),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(const Color(0xFFB71118)),
              ),
              child: const Text('Sauvegarder les modifications'),
            ),
          ],
        );
      },
    );
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 600,
            //color: Colors.red,
            child: Center(
              child: OpenStreetMapSearchAndPick(
                  center: LatLong(50.6371, 3.0530),
                  buttonColor: Colors.blue,
                  buttonText: 'Set Current Location',
                  onPicked: (pickedData) {
                    ShowDialog(context, pickedData);
                  }),
            ),
          );
        });
  }

  void ShowDialog(BuildContext context, PickedData pickedData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(
              "Confimez-vous la position choisie ? (${pickedData.address})"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Oui"),
              onPressed: () {
                pickedLatitude = pickedData.latLong.latitude;
                pickedLongitude = pickedData.latLong.longitude;
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Votre stand est désormais placé à l'adresse: ${pickedData
                              .address}")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pictures = [];
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _isLoggedIn = user != null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    String text = currentUser?.email ?? 'User is currently signed out!';

    return Scaffold(
        appBar: AppBar(
          title: const Text('Gérer mes stands'),
          backgroundColor: const Color(0xFFE19F0C),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('stand')
                          .where('userid', isEqualTo: currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 2,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 3 / 4,
                          child: ListView(
                            children: snapshot.data!.docs.map((snap) {
                              String id = snap.id;
                              return Card(
                                child: ListTile(
                                  title: Text(snap['description'].toString()),
                                  subtitle: Text(snap['mot-cles'].toString()),
                                  trailing: SizedBox(
                                    width: 80,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined),
                                            onPressed: () {
                                              // Define the edit function here
                                              _showEditForm(context, id);
                                              // find a way to pass id
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.delete_forever_outlined),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                    const Text("Confirmation"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this item?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text(
                                                            "Cancel"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text(
                                                            "Delete"),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'stand')
                                                              .doc(snap.id)
                                                              .delete();
                                                          // Define the delete function here
                                                          // e.g. FirebaseFirestore.instance.collection('documents').doc(snap.id).delete();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                ),

                Text(text),
                // const SizedBox(height: 30),
                // Visibility(
                //   visible: _isLoggedIn,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       await FirebaseAuth.instance.signOut();
                //     },
                //     child: const Text("Signout"),
                //   ),
                // ),
              ],
            )));
  }
}
