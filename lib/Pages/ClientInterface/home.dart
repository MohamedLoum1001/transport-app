import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tranport_app/Components/MessagesPage/messagesPage.dart';
import 'package:tranport_app/Components/Boutons/boutonReutilisable.dart';

class Home extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer le nom complet de l'utilisateur
  Future<String> _getUserName() async {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          return '${userData['prenom']} ${userData['nom']}'; // Affichage du prénom et nom
        }
      } catch (e) {
        print("Erreur lors de la récupération des données utilisateur: $e");
      }
    }

    return 'Utilisateur Inconnu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes Publiées'),
        backgroundColor: Colors.purple, // Couleur de fond violette pour l'AppBar
        flexibleSpace: Container(
          color: Colors.purple[300], // Changement de la couleur de fond de l'AppBar
        ),
      ),
      body: FutureBuilder<String>(
        future: _getUserName(), // Récupérer le nom de l'utilisateur
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final userName = snapshot.data ?? 'Utilisateur Inconnu';

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('demandes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final List<QueryDocumentSnapshot> demandes = snapshot.data!.docs;

              if (demandes.isEmpty) {
                return Center(child: Text('Aucune demande trouvée.'));
              }

              return ListView.builder(
                itemCount: demandes.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> demande = demandes[index].data() as Map<String, dynamic>;
                  return DemandCard(demande: demande, userName: userName);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DemandCard extends StatelessWidget {
  final Map<String, dynamic> demande;
  final String userName;

  DemandCard({required this.demande, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  demande['cargoType'] ?? 'Type inconnu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Type de camion: ${demande['truckType'] ?? 'Non spécifié'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'De ${demande['pickupLocation'] ?? 'Inconnu'} à ${demande['destinationLocation'] ?? 'Inconnu'}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Date : ${_formatDate(demande['pickupDate'])}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Publié par: $userName', // Affichage du prénom et nom de l'utilisateur connecté
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            // Utilisation du widget Center pour centrer le bouton
            Center(
              child: BoutonReutilisable(
                text: "Contacter", // Texte du bouton
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesPage(
                        demandeData: demande,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.purple, // Couleur de fond violette
                textColor: Colors.white, // Couleur du texte en blanc
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour formater la date
  String _formatDate(String? date) {
    if (date == null) return 'Non spécifiée';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return 'Format incorrect';
    }
  }
}
