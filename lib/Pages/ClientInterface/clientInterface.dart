// Pages/ClientInterface/client_interface.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Pages/ClientInterface/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';
import 'package:tranport_app/Pages/ClientInterface/home.dart'; // Importer la page Home

class ClientInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Mettre à jour le nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text("Interface Client"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Accueil'), // Ajouter un onglet Accueil
              Tab(text: 'Offres'),
              Tab(text: 'Demandes'),
              Tab(text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(), // Ajouter la page d'accueil
            SearchOffers(),
            MyDemands(),
            Profile(),
          ],
        ),
      ),
    );
  }
}
