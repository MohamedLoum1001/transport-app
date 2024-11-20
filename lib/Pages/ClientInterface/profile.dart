// Pages/ClientInterface/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profileImage;

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mon Profil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Affichage de l'image de profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // Bouton pour modifier le profil
            ElevatedButton(
              onPressed: () {
                _showEditProfileDialog(context);
              },
              child: Text('Modifier le Profil'),
            ),
            SizedBox(height: 10),

            // Bouton pour modifier le mot de passe
            ElevatedButton(
              onPressed: () {
                _showChangePasswordDialog(context);
              },
              child: Text('Modifier le Mot de Passe'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pour modifier le profil
  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.blue),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour enregistrer les modifications
                Navigator.of(context).pop();
                _showAlert(context, 'Profil mis à jour avec succès !');
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour modifier le mot de passe
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le Mot de Passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Ancien mot de passe'),
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Confirmer le nouveau mot de passe'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour enregistrer le nouveau mot de passe
                Navigator.of(context).pop();
                _showAlert(context, 'Mot de passe modifié avec succès !');
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher une alerte
  void _showAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
