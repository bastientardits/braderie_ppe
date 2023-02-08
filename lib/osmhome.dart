import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String locationaddress='Pick Location';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:Center(
        child: Container(
          child: InkWell(
        child: Text(locationaddress),
        onTap: (){
          _showModal(context);
        }),
    ),
      )
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
                    Navigator.pop(context); //popping modal bottom sheet
                    setState(() {
                      locationaddress='';
                      locationaddress+="Votre stand est désormais placé à l'adresse: ";
                      locationaddress+=pickedData.address;
                    });
                  }),

            ),
          );
        });
  }
 }

//modal bottom sheet


