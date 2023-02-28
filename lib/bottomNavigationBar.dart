import 'package:braderie_ppe/login_view.dart';
import 'package:braderie_ppe/osmhome.dart';
import 'package:flutter/material.dart';
import 'BDD.dart';
import 'tuto_accueil.dart';
import'profil.dart';
import 'new_stand.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();

}

class _NavBarState extends State<NavBar> {
  var selectedIndex = 0;

  void _onItemTapped(int index){
    setState(() {
      selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = tuto_accueil();
        break;
      case 1:
        page = Home();
        break;
      case 2:
        page = BDD();
        break;
      case 3:
        page = formulaireStand();
        break;
      case 4:
        page = Profil();
        break;
      case 5:
        page=LoginView();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body:page,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),//tooltip pour changer le label en haut
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Rechercher un objet'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'), //changer en map
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Créer un stand'), // intégrer placer un stand a info vendeur
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.login_rounded), label: 'Connexion'),

        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }
}
