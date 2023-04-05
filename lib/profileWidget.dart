import 'package:flutter/material.dart';
import 'profil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatelessWidget {
  @override


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 50),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profil.jpg'),
            ),
          ),
          SizedBox(height: 30),
          boutonStands(context, 'Mes stands'),
          SizedBox(height: 40),
          boutonLogout(context, 'Se déconnecter'),
        ],
      ),
    );
  }

  Widget boutonProfil(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(title),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFFE19F0C),
          ),
        ),
      ),
    );
  }


  Widget boutonStands(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profil()),
          );},
          child: Text(title),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFFE19F0C),
          ),
        ),
      ),
    );
  }

  Widget boutonLogout(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          child: Text(title),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFFA1161B),
          ),
        ),
      ),
    );
  }
}
