import 'package:flutter/material.dart';
import 'profil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 50),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
          ),
          SizedBox(height: 30),
          boutonProfil(context, 'Mon Profil'),
          boutonStatistiques(context, 'Statistiques'),
          boutonProfil(context, 'Paramètres'),
          boutonStands(context, 'Mes stands'),
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
            foregroundColor: Colors.orange, backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget boutonStatistiques(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(title),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orange, backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget boutonParametres(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(title),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orange, backgroundColor: Colors.white,
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
            foregroundColor: Colors.orange, backgroundColor: Colors.white,
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
            foregroundColor: Colors.orange, backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
