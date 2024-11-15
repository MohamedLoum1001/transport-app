import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:tranport_app/Pages/ClientInterface/clientInterface.dart';
import 'package:tranport_app/Pages/Login/Login.dart';
import 'package:tranport_app/Pages/Register/register.dart';
import 'package:tranport_app/Pages/TansporterInterface/transporterInteface.dart';
import 'package:tranport_app/Pages/ForgotPassword/forgotPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialise les widgets Flutter

  // Initialisation de Firebase avec configuration différente pour le web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAhDUrAd5SMYGI02JhN0fTNW6ZvpC_F7P4",
        authDomain: "transport-app-d3277.firebaseapp.com",
        projectId: "transport-app-d3277",
        storageBucket: "transport-app-d3277.appspot.com",
        messagingSenderId: "181272048951",
        appId: "1:181272048951:web:bcc9bbdf4ea5535a9516b2",
      ),
    );
  } else {
    await Firebase.initializeApp(); // Pour mobile et autres plateformes
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application Transport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/loading', // Affiche l'écran de chargement au démarrage
      routes: {
        '/loading': (context) => LoadingScreen(), // La page de chargement
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/transporterInterface': (context) => TransporterInterface(),
        '/clientInterface': (context) => ClientInterface(),
        '/forgotPassword': (context) => ForgotPassword(),
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Vérifie si l'utilisateur est déjà connecté
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Vérifie également l'état de connexion Firebase
    if (isLoggedIn && FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacementNamed('/clientInterface');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
