import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'osmhome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class formulaireStand extends StatefulWidget {
  const formulaireStand({Key? key}) : super(key: key);

  @override
  State<formulaireStand> createState() => _formulaireStandState();
}

class _formulaireStandState extends State<formulaireStand> {

  final _formKey = GlobalKey<FormState>();
  String locationaddress='Placer le stand';
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
  String? _selectedKeyword;
  List<String> _pictures = [];
  String imageUrl="";
  FirebaseStorage storage = FirebaseStorage.instance;
  bool _isLoggedIn = false;

  List<File> _images = [];
  double zero= 0.1;
  double pickedLongitude=0.1;
  double pickedLatitude=0.1;

  String _description="";
  String pickedAddress= "";


  Future<void> _pickImage(ImageSource source) async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images.addAll(pickedImages.map((pickedImage) => File(pickedImage.path)).toList());
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

  Future uploadPic(BuildContext context, List<String> _pictures) async{

    for(File _image in _images) {
      String fileName = basename(_image.path);
      int size=_images.length;


      String res = "${FirebaseAuth.instance.currentUser!.uid}/$fileName";

        _pictures.add(res);


      Reference reference = storage.ref().child(res);
      UploadTask uploadTask = reference.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      imageUrl = await reference.getDownloadURL();


    }

  }

  @override
  void initState() {
    super.initState();
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
    return SingleChildScrollView(
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
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Prendre une photo'),
                              onTap: ()  {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Choisir une image depuis la galerie'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF63AEEE)),
                ),
                child: const Text('Ajouter des photos'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci de remplir les cases prévues à cet effet';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Décrire votre stand en quelques mots'
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
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
              //stand PLACER
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Container(
                        child: ElevatedButton(
                            child: Text(locationaddress),
                            onPressed: (){
                                if(_isLoggedIn!=false)
                              {_showModal(context);}
                                else {
                                  _showModal2(context);
                                }

                            }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear the form when "Annuler" is pressed.
                        _formKey.currentState!.reset();
                        setState(() {
                          _selectedKeywords= [];
                        });

                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),),
                      child: const Text('Annuler'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate() && _isLoggedIn!=false) {
                          // If the form is valid, display a snackbar.
                          _submitForm();
                          uploadPic(context, _pictures).then((_) => FirebaseFirestore.instance
                              .collection('stand')
                              .add({
                            "address" : pickedAddress,
                            "latitude": pickedLatitude,
                            "longitude": pickedLongitude,
                            "pictures": _pictures,
                            "userid": FirebaseAuth.instance.currentUser?.uid.toString(),
                            "description" : _description,
                            "mot-cles" : _selectedKeywords,
                          }));

                          _formKey.currentState!.reset();
                          setState(() {
                            _selectedKeywords= [];
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sauvegarde du stand')),
                          );

                        }
                        if(_isLoggedIn==false){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Il faut se connecter pour placer un stand')),
                        );}

                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFFE19F0C)),
                      ),
                      child: const Text('Sauvegarder'),
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

  void _showModal(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SizedBox(
            height: 600,
            //color: Colors.red,
            child: Center(
              child: OpenStreetMapSearchAndPick(
                  center: LatLong(50.6371, 3.0530),
                  buttonColor: Colors.blue,
                  buttonText: 'Set Current Location',
                  onPicked: (pickedData) {
                    ShowDialog(context,pickedData);
                  }),
            ),
          );
        });
  }


  void _showModal2(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return const SizedBox(
            height: 600,
            //color: Colors.red,
            child: Center(
                child: Text("Vous devez vous connecter pour placer un stand...")
            ),
          );
        });
  }

  void ShowDialog(BuildContext context,PickedData pickedData)
  {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text("Confimez-vous la position choisie ? (${pickedData.address})"),
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
                pickedLatitude=pickedData.latLong.latitude;
                pickedLongitude=pickedData.latLong.longitude;
                pickedAddress= pickedData.address;
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Votre stand est désormais placé à l'adresse: ${pickedData.address}")),
                );
              },
            ),
          ],
        );
      },
    );

  }
}





