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



