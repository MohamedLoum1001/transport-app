import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tranport_app/Components/MessagesPage/messagesPage.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demandes Publiées')),
      body: StreamBuilder<QuerySnapshot>(
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
              return DemandCard(demande: demande);
            },
          );
        },
      ),
    );
  }
}

class DemandCard extends StatelessWidget {
  final Map<String, dynamic> demande;

  DemandCard({required this.demande});

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return '${userData['firstName']} ${userData['lastName']}';
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return 'Utilisateur Inconnu';
  }

  @override
  Widget build(BuildContext context) {
    final String userId = demande['userId'] ?? ''; // Assurez-vous que 'userId' est bien dans votre collection 'demandes'

    return FutureBuilder<String>(
      future: _getUserName(userId),
      builder: (context, snapshot) {
        String userName = 'Utilisateur Inconnu';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          userName = snapshot.data!;
        }

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
                  'Publié par: $userName',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
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
                    icon: Icon(Icons.contact_mail),
                    label: Text('Contacter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
