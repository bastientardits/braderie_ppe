import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'bottomNavigationBar.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String locationaddress='Pick Location';
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SafeArea(
              child: Container(
                child: InkWell(
                    child: Text(locationaddress),
                    onTap: (){
                      _showModal(context);
                    }),
              ),
            )
          ],
        ),
      );
  }


  void _showModal(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
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

  void ShowDialog(BuildContext context,PickedData pickedData)
  {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Confimez-vous la position choisie ?"),
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
                FirebaseFirestore.instance
                    .collection('stand')
                    .add({'address':pickedData.address,"latitude":  pickedData.latLong.latitude,"longitude": pickedData.latLong.longitude});

                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {
                  locationaddress = '';
                  locationaddress += "Votre stand est désormais placé à l'adresse: ";
                  locationaddress += pickedData.address;
                });
              },
            ),
          ],
        );
      },
    );

  }
 }

//modal bottom sheet


