import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class searchStand extends StatefulWidget {
  const searchStand({Key? key}) : super(key: key);

  @override
  State<searchStand> createState() => _searchStandState();
}

class _searchStandState extends State<searchStand> {
  final _formKey = GlobalKey<FormState>();
  List<String> _keywords = [
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
      List<String> keywordsList = _selectedKeywords ?? [];
      print('Description: $description');
      print('Keywords: ${keywordsList.join(', ')}');
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
                      selected: _selectedKeywords!.contains(keyword),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedKeywords!.add(keyword);
                          } else {
                            _selectedKeywords!.remove(keyword);
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
                        backgroundColor: MaterialStateProperty.all(Colors.red),),
                      child: Text('Annuler'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // display map with filter
                            print("map with filter");
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFE19F0C)),
                      ),//

                      child: Text('Rechercher'),
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



