import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

// Import des sous-pages
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart';
import 'package:tranport_app/Components/Profiles/profile.dart';
import 'package:tranport_app/Pages/ClientInterface/searchOffers.dart';
import 'package:tranport_app/Pages/ClientInterface/home.dart';
// import 'package:tranport_app/Pages/MessagesPage/messagesPage.dart';

class ClientInterface extends StatefulWidget {
  final File? profileImage;
  final String userName;

  const ClientInterface({Key? key, this.profileImage, this.userName = 'John Doe'}) : super(key: key);

  @override
  _ClientInterfaceState createState() => _ClientInterfaceState();
}

class _ClientInterfaceState extends State<ClientInterface> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key pour gérer le tiroir

  // Variables pour les notifications et messages
  int unreadMessages = 0; // Initialisé à 0
  int unreadNotifications = 0; // Initialisé à 0
  List<Map<String, String>> messages = []; // Liste des messages (avec prénom, nom et contenu)

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Méthode pour incrémenter les messages non lus
  void _incrementUnreadMessages() {
    setState(() {
      unreadMessages++;
    });
  }

  // Méthode pour incrémenter les notifications non lues
  void _incrementUnreadNotifications() {
    setState(() {
      unreadNotifications++;
    });
  }

  // Méthode pour réinitialiser les messages non lus lorsque l'utilisateur les lit
  void _resetUnreadMessages() {
    setState(() {
      unreadMessages = 0;
    });
  }

  // Méthode pour réinitialiser les notifications non lues lorsque l'utilisateur les lit
  void _resetUnreadNotifications() {
    setState(() {
      unreadNotifications = 0;
    });
  }

  // Fonction pour afficher les messages
  void _showMessages() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Messages'),
          content: messages.isEmpty
              ? Text('Vous n\'avez pas reçu de message')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: messages.map((message) {
                    return ListTile(
                      title: Text('${message['prenom']} ${message['nom']}'),
                      subtitle: Text(message['contenu'] ?? 'Aucun contenu'),
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () {
                // Réinitialiser les messages non lus quand l'utilisateur les lit
                _resetUnreadMessages();
                Navigator.pop(context);
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher les notifications
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: unreadNotifications == 0
              ? Text('Aucune notification reçue')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(unreadNotifications, (index) {
                    return ListTile(
                      title: Text('Notification ${index + 1}'),
                    );
                  }),
                ),
          actions: [
            TextButton(
              onPressed: () {
                // Réinitialiser les notifications quand l'utilisateur les lit
                _resetUnreadNotifications();
                Navigator.pop(context);
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey, // Ajout du key pour le Scaffold
        appBar: AppBar(
          title: Text("Transport App"),
          leading: IconButton(
            icon: Icon(_scaffoldKey.currentState?.isDrawerOpen == true
                ? Icons.close // Afficher l'icône de fermeture quand le tiroir est ouvert
                : Icons.menu), // Afficher l'icône de menu
            onPressed: () {
              if (_scaffoldKey.currentState?.isDrawerOpen == true) {
                Navigator.of(context).pop(); // Fermer le tiroir
              } else {
                _scaffoldKey.currentState?.openDrawer(); // Ouvrir le tiroir
              }
            },
          ),
          actions: [
            // Icône de message avec compteur
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: _showMessages, // Afficher les messages
                ),
                if (unreadMessages > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$unreadMessages',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            // Icône de notifications avec compteur
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: _showNotifications, // Afficher les notifications
                ),
                if (unreadNotifications > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$unreadNotifications',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Accueil'),
              Tab(icon: Icon(Icons.search), text: 'Offres'),
              Tab(icon: Icon(Icons.assignment), text: 'Demandes'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
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
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(_auth.currentUser?.displayName ?? 'Utilisateur'),
                accountEmail: Text(_auth.currentUser?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      widget.profileImage != null ? FileImage(widget.profileImage!) : null,
                  child: widget.profileImage == null ? Icon(Icons.person) : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Accueil'),
                onTap: () => DefaultTabController.of(context)?.animateTo(0),
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Offres'),
                onTap: () => DefaultTabController.of(context)?.animateTo(1),
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Demandes'),
                onTap: () => DefaultTabController.of(context)?.animateTo(2),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profil'),
                onTap: () => DefaultTabController.of(context)?.animateTo(3),
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
