import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool _isLoggedIn = false;

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
    var currentUser = FirebaseAuth.instance.currentUser;
    String text = currentUser?.email ?? 'User is currently signed out!';

    return Scaffold(
        appBar: AppBar(
        title: Text('Profil'),
          backgroundColor:  Color(0xFFE19F0C),
    ),
    body : Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(stream:FirebaseFirestore.instance
        .collection('stand')
        .where('userid', isEqualTo: currentUser?.uid)
        .snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width*3/4,
            child: ListView(
              children: snapshot.data!.docs.map((snap){
                return Card(
                  child : ListTile(
                    leading :Icon(Icons.edit),
                    title:Text(snap['address'].toString()),
                    subtitle: Text(snap['longitude'].toString()),
                    trailing: Icon(Icons.delete),
                  )
                );
              }).toList()
            )
          );

        }
        ),

        Text(text),
        const SizedBox(height: 30),
        Visibility(
          visible: _isLoggedIn,
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("Signout"),
          ),
        ),

      ],
    )
    )
    );
  }
}

void retrieveSubCol()
{
  FirebaseFirestore.instance.collection("users").get().then((value){
    value.docs.forEach((result) {
      FirebaseFirestore.instance.collection("users")
          .doc(result.id)
          .collection("stand")
          .get()
          .then((subcol){
            subcol.docs.forEach((element) {
              print(element.data());
            });
      });
    });
  });
}
void retrieveDocUsingCondition()
{

}