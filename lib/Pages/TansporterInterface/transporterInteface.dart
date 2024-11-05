// screens/transporter_interface.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyOffers.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyTransports.dart';
import 'package:tranport_app/Pages/TansporterInterface/Profile.dart';
import 'package:tranport_app/Pages/TansporterInterface/SearchDemands.dart';
import 'package:tranport_app/Pages/TansporterInterface/UpdateStatus.dart';


class TransporterInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Interface Transporteur"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Demandes'),
              Tab(text: 'Offres'),
              Tab(text: 'Profil'),
              Tab(text: 'Transports'),
              Tab(text: 'Statut'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchDemandsDriver(),
            MyOffersDriver(),
            ProfileDriver(),
            MyTransportsDriver(),
            UpdateStatusDriver(),
          ],
        ),
      ),
    );
  }
}
