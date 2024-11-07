// Pages/ClientInterface/home.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Naviguer vers la page de demande lorsqu'on clique sur le bouton
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyDemands()),
            );
          },
          child: Text('Faire une Demande'),
        ),
      ),
    );
  }
}
