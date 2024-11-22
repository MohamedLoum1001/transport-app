import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Pour générer des ID uniques

class MyDemands extends StatefulWidget {
  @override
  _MyDemandsState createState() => _MyDemandsState();
}

class _MyDemandsState extends State<MyDemands> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid(); // Générateur d'ID unique

  // Variables pour stocker les données du formulaire
  String? selectedCargoType;
  String? selectedTruckType;
  String? pickupDate;
  String? pickupLocation;
  String? destinationLocation;

  // Liste des types de marchandises et camions
  final List<String> cargoTypes = [
    'Nourriture',
    'Transport de Voitures',
    'Transport Réfrigéré',
    'Liquides Alimentaires',
    'Animaux',
  ];

  final List<String> truckTypes = ['Tous', 'Petit', 'Léger', 'Moyen', 'Lourd'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Demandes')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('demandes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(child: Text('Aucune demande trouvée.'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final demand = docs[index].data() as Map<String, dynamic>;
                    final demandId = docs[index].id;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            // Boutons pour contacter, modifier, ou supprimer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Action pour contacter l'utilisateur
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Contactez-moi pour cette demande.')),
                                    );
                                  },
                                  child: Text('Contactez-moi'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Action pour modifier la demande
                                    _showEditDemandForm(demandId, demand);
                                  },
                                  child: Text('Modifier ma Demande'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Action pour supprimer la demande
                                    _deleteDemand(demandId);
                                  },
                                  child: Text('Supprimer ma Demande'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showCreateDemandForm,
              child: Text('Faire une Demande'),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher le formulaire de création de demande
  void _showCreateDemandForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Créer une Demande Logistique'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type de Marchandise'),
                  items: cargoTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCargoType = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Dimensions (L x l x h)'),
                  keyboardType: TextInputType.text,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type de Camion'),
                  items: truckTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedTruckType = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date de Ramassage'),
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      pickupDate = pickedDate.toString();
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Lieu de Ramassage'),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    pickupLocation = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Lieu de Destination'),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    destinationLocation = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: _submitRequest,
            child: Text('Soumettre'),
          ),
        ],
      ),
    );
  }

  // Fonction pour soumettre une nouvelle demande
  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final String id = _uuid.v4();

      await _firestore.collection('demandes').doc(id).set({
        'id': id,
        'cargoType': selectedCargoType,
        'truckType': selectedTruckType,
        'pickupDate': pickupDate,
        'pickupLocation': pickupLocation,
        'destinationLocation': destinationLocation,
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande soumise avec succès')),
      );
    }
  }

  // Fonction pour afficher le formulaire de modification
  void _showEditDemandForm(String demandId, Map<String, dynamic> demand) {
    // Vous pouvez ajouter un formulaire pour modifier les données ici
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ma Demande'),
        content: Column(
          children: [
            // Ajoutez ici les champs pour modifier la demande (ex: type de camion, lieu de ramassage, etc.)
            Text('Formulaire de modification pour la demande $demandId'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Mettre à jour la demande ici avec les nouvelles valeurs
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  // Fonction pour supprimer la demande
  Future<void> _deleteDemand(String demandId) async {
    await _firestore.collection('demandes').doc(demandId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Demande supprimée avec succès')),
    );
  }
}
