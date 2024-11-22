import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Pour formater la date et l'heure
import 'package:tranport_app/Pages/ClientInterface/myDemands.dart'; // Importer la page "Faire une Demande"

class Home extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section pour afficher les demandes existantes
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('demandes').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot> demandDocs = snapshot.data!.docs;

                if (demandDocs.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucune demande trouvée.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: demandDocs.length,
                  itemBuilder: (context, index) {
                    final demand = demandDocs[index].data() as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: _firestore.collection('users').doc(demand['userId']).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox(); // Si les données utilisateur ne sont pas encore disponibles
                        }

                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        final timestamp = (demand['timestamp'] as Timestamp).toDate();

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('${demand['cargoType']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Utilisateur : ${userData['firstName']} ${userData['lastName']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Ramassage : ${demand['pickupLocation']}',
                                ),
                                Text(
                                  'Destination : ${demand['destinationLocation']}',
                                ),
                                Text(
                                  'Date : ${DateFormat('dd/MM/yyyy').format(timestamp)}',
                                ),
                                Text(
                                  'Heure : ${DateFormat('HH:mm').format(timestamp)}',
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Bouton pour accéder à la page "Faire une Demande"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers la page des demandes
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDemands()),
                );
              },
              child: Text('Faire une Demande'),
            ),
          ),
        ],
      ),
    );
  }
}
