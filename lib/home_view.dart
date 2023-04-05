import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compte créé'),
        backgroundColor: const Color(0xFFE19F0C),
      ),
      body: const Center(
        child: Text('Votre compte a bien été crée, appuyez sur le flèche en haut a gauche pour revenir à l\'application')
      ),
    );
  }
}
