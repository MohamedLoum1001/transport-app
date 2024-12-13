import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOffersDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Offres")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('offers')
            .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Aucune offre publiée."));
          }

          final offers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(offer['description'] ?? "Sans description"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date : ${offer['date'] ?? "Non spécifiée"}"),
                      Text("Statut : ${offer['status'] ?? "Non spécifié"}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditOfferForm(offerId: offer.id, initialData: offer),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('offers')
                              .doc(offer.id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Offre supprimée avec succès.")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddOfferForm extends StatefulWidget {
  @override
  _AddOfferFormState createState() => _AddOfferFormState();
}

class _AddOfferFormState extends State<AddOfferForm> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? status;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> addOffer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('offers').add({
            'description': descriptionController.text,
            'date': dateController.text,
            'status': status,
            'driverId': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Offre ajoutée avec succès.")),
          );
          Navigator.pop(context);
        } else {
          throw Exception("Utilisateur non connecté.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une offre")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description de l'offre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une description.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Date (AAAA-MM-JJ)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une date.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: "Statut",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "choisissez",
                      child: Text("Choisissez votre statut"),
                    ),
                     DropdownMenuItem(
                      value: "disponible",
                      child: Text("Disponible"),
                    ),
                    DropdownMenuItem(
                      value: "en mission",
                      child: Text("En mission"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner un statut.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: addOffer,
                        child: Text("Ajouter"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditOfferForm extends StatefulWidget {
  final String offerId;
  final QueryDocumentSnapshot initialData;

  EditOfferForm({required this.offerId, required this.initialData});

  @override
  _EditOfferFormState createState() => _EditOfferFormState();
}

class _EditOfferFormState extends State<EditOfferForm> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? status;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.initialData['description'] ?? '';
    dateController.text = widget.initialData['date'] ?? '';
    status = widget.initialData['status'] ?? null;
  }

  Future<void> updateOffer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection('offers')
            .doc(widget.offerId)
            .update({
          'description': descriptionController.text,
          'date': dateController.text,
          'status': status,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Offre mise à jour avec succès.")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.toString()}")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier l'offre")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description de l'offre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une description.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Date (AAAA-MM-JJ)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une date.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration:                   InputDecoration(
                    labelText: "Statut",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "choisissez",
                      child: Text("Choisissez votre statut"),
                    ),
                    DropdownMenuItem(
                      value: "disponible",
                      child: Text("Disponible"),
                    ),
                    DropdownMenuItem(
                      value: "en mission",
                      child: Text("En mission"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez sélectionner un statut.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: updateOffer,
                        child: Text("Mettre à jour"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
