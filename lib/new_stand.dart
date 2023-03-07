import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class formulaireStand extends StatefulWidget {
  const formulaireStand({Key? key}) : super(key: key);

  @override
  State<formulaireStand> createState() => _formulaireStandState();
}

class _formulaireStandState extends State<formulaireStand> {
  final _formKey = GlobalKey<FormState>();
  List<String> _keywords = [
    'Vêtements',
    'Musique',
    'Antiquités',
  ];
  String? _selectedKeyword;
  List<File> _images = [];
  String _description="";




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
      print('Description: $description');
      print('Keywords: $keywords');
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
                              leading: Icon(Icons.camera_alt),
                              title: Text('Prendre une photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Choisir une image depuis la galerie'),
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
                  backgroundColor: MaterialStateProperty.all(Color(0xFFE19F0C)),
                ),//
                child: Text('Ajouter des photos'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci de remplir les cases prévues à cet effet';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Décrire votre stand en quelques mots'
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _selectedKeyword,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKeyword = newValue;
                  });
                },
                items: _keywords.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Sélectionner un mot-clé'),
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
                        backgroundColor: MaterialStateProperty.all(Colors.red),),
                      child: Text('Annuler'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar.
                          _submitForm();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Sauvegarde du stand')),
                          // );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.amber),
                      ),
                      child: Text('Sauvegarder'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sauvegarde et placement du stand')),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFE19F0C)),
                      ),//

                      child: Text('Sauvegarder et placer'),
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



