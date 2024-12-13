import 'package:flutter/material.dart';
import 'package:tranport_app/Components/Profiles/profile.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyOffers.dart';
import 'package:tranport_app/Pages/TansporterInterface/MyTransports.dart';
// import 'package:tranport_app/Pages/TansporterInterface/ProfileDriver.dart';
import 'package:tranport_app/Pages/TansporterInterface/SearchDemands.dart';
import 'package:tranport_app/Pages/TansporterInterface/UpdateStatus.dart';
import 'dart:io';

class TransporterInterface extends StatelessWidget {
  final File? profileImage; // Pass the profile image file
  final String userName; // Pass the username

  TransporterInterface({this.profileImage, this.userName = 'John Doe'});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 10 : 14;
    double avatarRadius = screenWidth < 360 ? 15 : 20;
    double iconSize = screenWidth < 360 ? 18 : 24;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Interface Transporteur",
                  style: TextStyle(fontSize: fontSize + 4),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message, size: iconSize, color: Colors.black),
                    onPressed: () {
                      // Logique pour ouvrir la messagerie
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, size: iconSize, color: Colors.black),
                    onPressed: () {
                      // Logique pour ouvrir les notifications
                    },
                  ),
                  if (screenWidth >= 600)
                    Flexible(
                      child: Text(
                        userName,
                        style: TextStyle(fontSize: fontSize),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app, size: iconSize),
                            SizedBox(width: 8),
                            Text('Déconnexion', style: TextStyle(fontSize: fontSize)),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null ? Icon(Icons.person, size: iconSize) : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: screenWidth < 400,
            tabs: [
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.search, size: iconSize),
                    Text('Demandes', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.local_offer, size: iconSize),
                    Text('Offres', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.person, size: iconSize),
                    Text('Profil', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.directions_car, size: iconSize),
                    Text('Transports', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.update, size: iconSize),
                    Text('Statut', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchDemandsDriver(),
            MyOffersDriver(),
            Profile(),
            MyTransportsDriver(),
            UpdateStatusDriver(),
          ],
        ),
      ),
    );
  }
}
