import 'package:braderie_ppe/login_view.dart';
import 'package:flutter/material.dart';
import 'search.dart';
import'profileWidget.dart';
import 'new_stand.dart';
import 'accueil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'popupMap.dart';

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
  void onLoginSuccess(int selectedIndex) {
    setState(() {
      selectedIndex=0;
    });
  }

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

  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    Widget page;
    Widget acceuil=accueil();
    //Widget home=Home(); //marker placer
    Widget home=searchStand();
    Widget Bdd=PopupMap();
    Widget formulaire=formulaireStand();
    //Widget profil=Profil();
    Widget profileWidget=ProfileWidget();
    Widget login = LoginView(onLoginSuccess: (index) { // Passez la fonction de rappel ici
      setState(() {
        selectedIndex = index;
      });
    });

    switch (selectedIndex) {
      case 0:
        page = acceuil;
        break;
      case 1:
        page = home;
        break;
      case 2:
        page = Bdd;
        break;
      case 3:
        page = formulaire;
        break;
      case 4:
        page = _isLoggedIn? profileWidget : login;
        break;
      /*case 5:
        page = login;
        break;*/
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
          //BottomNavigationBarItem(icon: Icon(Icons.login_rounded), label: 'Connexion'),

        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }
}
