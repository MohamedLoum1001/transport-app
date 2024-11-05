// Pages/ClientInterface/client_interface.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Pages/ClientInterface/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';


class ClientInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Interface Client"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Offres'),
              Tab(text: 'Demandes'),
              Tab(text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchOffers(),
            MyDemands(),
            Profile(),
          ],
        ),
      ),
    );
  }
}
