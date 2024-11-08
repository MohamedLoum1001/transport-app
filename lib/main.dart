import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/clientInterface.dart';
import 'package:tranport_app/Pages/Login/Login.dart';
import 'package:tranport_app/Pages/Register/register.dart';
import 'package:tranport_app/Pages/TansporterInterface/transporterInteface.dart';
import 'package:tranport_app/Pages/ForgotPassword/forgotPassword.dart'; // Assurez-vous que cette page existe

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application Transport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Page d'accueil par défaut
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/transporterInterface': (context) => TransporterInterface(),
        '/clientInterface': (context) => ClientInterface(),
        '/forgotPassword': (context) => ForgotPassword(), // La nouvelle route
      },
    );
  }
}
