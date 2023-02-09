import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BDD extends StatefulWidget {
  const BDD({Key? key}) : super(key: key);

  @override
  State<BDD> createState() => _BDDState();
}

class _BDDState extends State<BDD> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('stand').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container( //aa
                child: Center(child: Text(document['address'])),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
