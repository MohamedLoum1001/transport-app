import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tranport_app/Components/Boutons/boutonReutilisable.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour réinitialiser le mot de passe
  void resetPassword() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showErrorDialog("Veuillez entrer un email.");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      showErrorDialog("Veuillez entrer un email valide.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Un e-mail de réinitialisation a été envoyé à $email.")),
      );

      Navigator.pop(context);
    } catch (e) {
      showErrorDialog("Erreur lors de l'envoi de l'email : ${e.toString()}");
    }
  }

  // Méthode pour afficher les erreurs
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Retour à la page précédente (Login)
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ Email avec style personnalisé
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Entrez votre e-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Bouton Réinitialiser le mot de passe avec BoutonReutilisable
            BoutonReutilisable(
              text: 'Réinitialiser le mot de passe',
              onPressed: resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
