import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  void resetPassword() {
    // Logique pour réinitialiser le mot de passe, par exemple envoyer un email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Un e-mail de réinitialisation a été envoyé.")),
    );
    // Retourner à la page de connexion
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mot de passe oublié')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Entrez votre e-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: Text('Réinitialiser le mot de passe'),
            ),
          ],
        ),
      ),
    );
  }
}
