import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDemandsDriver extends StatefulWidget {
  @override
  _SearchDemandsDriverState createState() => _SearchDemandsDriverState();
}

class _SearchDemandsDriverState extends State<SearchDemandsDriver> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = ""; // Stocke la saisie de l'utilisateur
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rechercher des demandes"),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // Recherche insensible à la casse
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher des demandes", // Texte du placeholder
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Liste des demandes filtrées
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('demandes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                // Filtrer les résultats selon la recherche
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['cargoType']
                          ?.toLowerCase()
                          ?.contains(searchQuery) ??
                      false; // Recherche dans le champ "cargoType"
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Text("Aucune demande correspondante trouvée."),
                  );
                }

                // Construire la liste des demandes
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final demand = filteredDocs[index].data() as Map<String, dynamic>;

                    return _buildDemandCard(demand);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour construire une carte de demande
  Widget _buildDemandCard(Map<String, dynamic> demand) {
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
                  demand['cargoType'] ?? 'Type inconnu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Type de camion: ${demand['truckType'] ?? 'Non spécifié'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'De ${demand['pickupLocation'] ?? 'Inconnu'} à ${demand['destinationLocation'] ?? 'Inconnu'}',
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
                  'Date : ${demand['pickupDate'] ?? 'Non spécifiée'}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
