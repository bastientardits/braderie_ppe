import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class tuto_accueil extends StatefulWidget {
  const tuto_accueil({Key? key}) : super(key: key);
  @override
  State<tuto_accueil> createState() => _tuto_accueilState();
}

class _tuto_accueilState extends State<tuto_accueil> {
  String text = '';
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        text = currentUser!.email!;
      });
    } else {
      setState(() {
        text = 'User is currently signed out!';
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      text = 'You have been logged out.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(height: 30),
            if (currentUser != null)
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Sign out'),
              ),
          ],
        ),
      ),
    );
  }
}
