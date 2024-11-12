import 'package:flutter/material.dart';
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Pages/ClientInterface/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';
import 'package:tranport_app/Pages/ClientInterface/home.dart'; // Importer la page Home
import 'dart:io';

class ClientInterface extends StatelessWidget {
  final File? profileImage; // Pass the profile image file
  final String userName; // Pass the username

  ClientInterface({this.profileImage, this.userName = 'John Doe'});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Interface Client"),
              Row(
                children: [
                 
                  SizedBox(width: 5), // Set a 5px margin between name and image

                  // Icon for messages
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.black),
                    onPressed: () {
                      // Logique pour ouvrir la messagerie
                    },
                  ),

                  // Icon for notifications
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {
                      // Logique pour ouvrir les notifications
                    },
                  ),

                  Text(
                    userName,
                    style: TextStyle(fontSize: 14), // Smaller font size for username
                  ),
                  // Profile picture with popup for logout
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        // Déconnexion : rediriger vers la page de login
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
              Tab(text: 'Accueil'),
              Tab(text: 'Offres'),
              Tab(text: 'Demandes'),
              Tab(text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(),
            SearchOffers(),
            MyDemands(),
            Profile(),
          ],
        ),
      ),
    );
  }
}
