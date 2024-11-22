import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

// Import des sous-pages
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Pages/ClientInterface/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';
// import 'package:tranport_app/Pages/ClientInterface/home.dart';

class ClientInterface extends StatefulWidget {
  final File? profileImage;
  final String userName;

  const ClientInterface({Key? key, this.profileImage, this.userName = 'John Doe'}) : super(key: key);

  @override
  _ClientInterfaceState createState() => _ClientInterfaceState();
}

class _ClientInterfaceState extends State<ClientInterface> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Interface Client"),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {}, // Action notifications
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') _logout();
              },
              itemBuilder: (context) => [
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
            ),
          ],
          bottom: TabBar(
            tabs: [
              // Tab(icon: Icon(Icons.home), text: 'Accueil'),
              Tab(icon: Icon(Icons.search), text: 'Offres'),
              Tab(icon: Icon(Icons.assignment), text: 'Demandes'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Home(),
            SearchOffers(),
            MyDemands(),
            Profile(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.userName),
                accountEmail: Text(_auth.currentUser?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      widget.profileImage != null ? FileImage(widget.profileImage!) : null,
                  child: widget.profileImage == null ? Icon(Icons.person) : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Offres'),
                onTap: () => DefaultTabController.of(context)?.animateTo(0),
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Demandes'),
                onTap: () => DefaultTabController.of(context)?.animateTo(1),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profil'),
                onTap: () => DefaultTabController.of(context)?.animateTo(2),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Déconnexion'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
