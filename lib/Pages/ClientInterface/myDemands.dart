// Pages/ClientInterface/my_demands_screen.dart
import 'package:flutter/material.dart';

class MyDemands extends StatefulWidget {
  @override
  _MyDemandsState createState() => _MyDemandsState();
}

class _MyDemandsState extends State<MyDemands> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables pour stocker les données du formulaire
  String? selectedCargoType;
  String? selectedTruckType;
  String? selectedPaymentType;
  String? pickupDate;
  String? pickupLocation;
  String? destinationLocation;

  // Liste des types de marchandises et camions
  final List<String> cargoTypes = [
    'Nourriture Générale', 'Transport en Vrac', 'Transport de Voitures', 
    'Transport Réfrigéré', 'Liquides Alimentaires', 'Animaux Vivants', 
    'Transport Exceptionnel', 'Nourriture Dangereuse'
  ];

  final List<String> truckTypes = ['Tous', 'Petit', 'Léger', 'Moyen', 'Lourd'];
  final List<String> paymentTypes = ['Prix Fixe', 'Demander un devis', 'Méthode de paiement'];

  // Liste pour stocker les demandes du client
  List<Map<String, String?>> demands = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Demandes')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: demands.length,
              itemBuilder: (context, index) {
                final demand = demands[index];
                return ListTile(
                  title: Text('${demand['cargoType']}'),
                  subtitle: Text('Ramassage: ${demand['pickupLocation']} - Destination: ${demand['destinationLocation']}'),
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type de Paiement'),
                  items: paymentTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPaymentType = value;
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

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Ajouter la nouvelle demande à la liste des demandes
      setState(() {
        demands.add({
          'cargoType': selectedCargoType,
          'truckType': selectedTruckType,
          'paymentType': selectedPaymentType,
          'pickupDate': pickupDate,
          'pickupLocation': pickupLocation,
          'destinationLocation': destinationLocation,
        });
      });

      // Fermer le formulaire de création de demande
      Navigator.pop(context);

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande soumise avec succès')),
      );
    }
  }
}
