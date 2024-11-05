// screens/register_screen.dart
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController givenNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedUserType = 'Client'; // Définit 'Client' par défaut

  void registerUser() {
    if (passwordController.text != confirmPasswordController.text) {
      showErrorDialog("Les mots de passe ne correspondent pas");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Inscription réussie"),
          content: Text("Bienvenue, $selectedUserType!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erreur d'inscription"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: givenNameController, decoration: InputDecoration(labelText: 'Prénom')),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Téléphone')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: 'Confirmer mot de passe'), obscureText: true),
            DropdownButtonFormField<String>(
              value: selectedUserType,
              items: [
                DropdownMenuItem(value: 'Client', child: Text('Client')),
                DropdownMenuItem(value: 'Transporteur', child: Text('Transporteur')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedUserType = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Type de profil'),
            ),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
