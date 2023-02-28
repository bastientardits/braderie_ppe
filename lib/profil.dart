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
    ),
    body :
    Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
