// main.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/clientInterface.dart';
import 'package:tranport_app/Pages/Login/Login.dart';
import 'package:tranport_app/Pages/Register/register.dart';
import 'package:tranport_app/Pages/TansporterInterface/transporterInteface.dart';


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
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Register(),
        '/transporterInterface': (context) => TransporterInterface(),
        '/clientInterface': (context) => ClientInterface(),
      },
    );
  }
}
