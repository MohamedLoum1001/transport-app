import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tranport_app/Components/MessagesPage/messagesPage.dart';
import 'package:uuid/uuid.dart';

class MyDemands extends StatefulWidget {
  @override
  _MyDemandsState createState() => _MyDemandsState();
}

class _MyDemandsState extends State<MyDemands> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  // Variables pour stocker les données du formulaire
  String? selectedCargoType;
  String? selectedTruckType;
  String? pickupDate;
  String? pickupLocation;
  String? destinationLocation;

  // Types de marchandises et camions
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
          // Afficher les demandes existantes
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

                    return _buildDemandCard(demandId, demand);
                  },
                );
              },
            ),
          ),
          // Bouton pour ajouter une demande
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

  // Construire une carte pour chaque demande
  Widget _buildDemandCard(String demandId, Map<String, dynamic> demand) {
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MessagesPage(demandeData: demand), // Passage de demandeData
  ),
);
                  },
                  child: Icon(Icons.contact_mail, color: Colors.green),
                  style: OutlinedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                    side: BorderSide(color: Colors.green),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showEditDemandForm(demandId, demand),
                  child: Icon(Icons.edit, color: Colors.orange),
                  style: OutlinedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                    side: BorderSide(color: Colors.orange),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _deleteDemand(demandId),
                  child: Icon(Icons.delete, color: Colors.red),
                  style: OutlinedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Créer une nouvelle demande
  void _showCreateDemandForm() {
    _resetForm();
    _showDemandForm(title: 'Créer une Demande', onSubmit: _submitRequest);
  }

  // Modifier une demande existante
  void _showEditDemandForm(String demandId, Map<String, dynamic> demand) {
    setState(() {
      selectedCargoType = demand['cargoType'];
      selectedTruckType = demand['truckType'];
      pickupDate = demand['pickupDate'];
      pickupLocation = demand['pickupLocation'];
      destinationLocation = demand['destinationLocation'];
    });

    _showDemandForm(
      title: 'Modifier la Demande',
      onSubmit: () => _updateDemand(demandId),
    );
  }

  // Fonction pour afficher le formulaire de demande
  void _showDemandForm({required String title, required VoidCallback onSubmit}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDropdownField(
                  label: 'Type de Marchandise',
                  items: cargoTypes,
                  value: selectedCargoType,
                  onChanged: (value) => selectedCargoType = value,
                ),
                _buildDropdownField(
                  label: 'Type de Camion',
                  items: truckTypes,
                  value: selectedTruckType,
                  onChanged: (value) => selectedTruckType = value,
                ),
                _buildDateField(),
                _buildTextField(
                  label: 'Lieu de Ramassage',
                  value: pickupLocation,
                  onChanged: (value) => pickupLocation = value,
                ),
                _buildTextField(
                  label: 'Lieu de Destination',
                  value: destinationLocation,
                  onChanged: (value) => destinationLocation = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          ElevatedButton(onPressed: onSubmit, child: Text('Soumettre')),
        ],
      ),
    );
  }

  // Widgets des champs du formulaire
  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Ce champ est requis' : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date de Ramassage',
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
      ),
      controller: TextEditingController(text: pickupDate),
      validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
    );
  }

  // Sélection de la date
  Future<void> _selectDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selected != null) {
      setState(() {
        pickupDate = '${selected.day}/${selected.month}/${selected.year}';
      });
    }
  }

  // Soumettre une demande
  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('demandes').add({
        'id': _uuid.v4(),
        'cargoType': selectedCargoType,
        'truckType': selectedTruckType,
        'pickupDate': pickupDate,
        'pickupLocation': pickupLocation,
        'destinationLocation': destinationLocation,
      });

      Navigator.pop(context); // Fermer le formulaire
      _resetForm();
    }
  }

  // Mettre à jour une demande existante
  Future<void> _updateDemand(String demandId) async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('demandes').doc(demandId).update({
        'cargoType': selectedCargoType,
        'truckType': selectedTruckType,
        'pickupDate': pickupDate,
        'pickupLocation': pickupLocation,
        'destinationLocation': destinationLocation,
      });

      Navigator.pop(context); // Fermer le formulaire
      _resetForm();
    }
  }

  // Supprimer une demande
  Future<void> _deleteDemand(String demandId) async {
    await _firestore.collection('demandes').doc(demandId).delete();
  }

  // Réinitialiser les champs du formulaire
  void _resetForm() {
    setState(() {
      selectedCargoType = null;
      selectedTruckType = null;
      pickupDate = null;
      pickupLocation = null;
      destinationLocation = null;
    });
  }
}
