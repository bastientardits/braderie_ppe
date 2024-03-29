import 'package:braderie_ppe/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'tuto_accueil.dart';
import 'osmhome.dart';
import 'bottomNavigationBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_view.dart';

 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //Test contribution Fares
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo',
    theme: ThemeData(
    // This is the theme of your application.
    //
    // Try running your application with "flutter run". You'll see the
    // application has a blue toolbar. Then, without quitting the app, try
    // changing the primarySwatch below to Colors.green and then invoke
    // "hot reload" (press "r" in the console where you ran "flutter run",
    // or simply save your changes to "hot reload" in a Flutter IDE).
    // Notice that the counter didn't reset back to zero; the application
    // is not restarted.
    primarySwatch: Colors.blue,
    ),
    home: const tuto_accueil(),
    );
  }
}

/*



// Récupérer la référence de la base de données Firebase qui contient le tableau d'images
DatabaseReference picturesRef = FirebaseDatabase.instance.reference().child('pictures');

// Définir la chaîne de caractères à supprimer
String stringToRemove = 'https://example.com/image.jpg';

// Utiliser la méthode "runTransaction" pour créer une transaction afin de mettre à jour le tableau de chaînes de caractères
picturesRef.runTransaction((MutableData transaction) async {
  // Récupérer le tableau de chaînes de caractères actuel
  List<dynamic> pictures = transaction.value;

  // Vérifier si la chaîne de caractères à supprimer est présente dans le tableau
  int indexToRemove = pictures.indexOf(stringToRemove);
  if (indexToRemove != -1) {
    // Supprimer la chaîne de caractères du tableau
    pictures.removeAt(indexToRemove);

    // Mettre à jour le tableau de chaînes de caractères dans la transaction
    transaction.value = pictures;

    // Terminer la transaction en retournant la nouvelle valeur du tableau de chaînes de caractères
    return transaction;
  } else {
    // La chaîne de caractères à supprimer n'est pas présente dans le tableau
    return null;
  }
}).then((result) {
  if (result != null) {
    print('Chaîne de caractères supprimée avec succès');
  } else {
    print('La chaîne de caractères à supprimer n\'a pas été trouvée');
  }
}).catchError((error) {
  print('Erreur lors de la suppression de la chaîne de caractères : $error');
});

 */


