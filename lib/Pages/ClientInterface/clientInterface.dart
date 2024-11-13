import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Pages/ClientInterface/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';
import 'package:tranport_app/Pages/ClientInterface/home.dart';
import 'dart:io';

class ClientInterface extends StatelessWidget {
  final File? profileImage;
  final String userName;

  ClientInterface({this.profileImage, this.userName = 'John Doe'});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 400 ? 12 : 14;
    double iconSize = screenWidth < 360 ? 18 : 24;
    double avatarRadius = screenWidth < 400 ? 16 : 20;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Interface Client", style: TextStyle(fontSize: fontSize + 4)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.black, size: iconSize),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.black, size: iconSize),
                    onPressed: () {},
                  ),
                  if (screenWidth >= 600)
                    Text(userName, style: TextStyle(fontSize: fontSize)),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 10),
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
            tabs: [
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.home, size: iconSize),
                    Text('Accueil', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.search, size: iconSize),
                    Text('Offres', style: TextStyle(fontSize: fontSize)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.assignment, size: iconSize),
                    Text('Demandes', style: TextStyle(fontSize: fontSize)),
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Home(),
              ),
            ),
            SingleChildScrollView(child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: SearchOffers(),
              ),
            ),
            SingleChildScrollView(child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: MyDemands(),
              ),
            ),
            SingleChildScrollView(child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Profile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
