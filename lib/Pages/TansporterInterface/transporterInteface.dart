// screens/transporter_interface.dart
import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyOffers.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyTransports.dart';
import 'package:tranport_app/Pages/TansporterInterface/Profile.dart';
import 'package:tranport_app/Pages/TansporterInterface/SearchDemands.dart';
import 'package:tranport_app/Pages/TansporterInterface/UpdateStatus.dart';
import 'dart:io';


class TransporterInterface extends StatelessWidget {
  final File? profileImage; // Pass the profile image file
  final String userName; // Pass the username

    TransporterInterface({this.profileImage, this.userName = 'John Doe'});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Interface Transporteur"),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      // Logique pour ouvrir la messagerie
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // Logique pour ouvrir les notifications
                    },
                  ),
                   Text(
                    userName,
                    style: TextStyle(fontSize: 14), // Smaller font size for username
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        // Logique de déconnexion, par exemple :
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 8),
                            Text('Déconnexion'),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null ? Icon(Icons.person) : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
