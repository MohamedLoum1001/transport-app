import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() {
    // Redirection vers l'interface transporteur
    Navigator.pushReplacementNamed(context, '/transporterInterface');
    // Redirection vers l'interface Client
    // Navigator.pushReplacementNamed(context, '/clientInterface');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Se connecter'),
            ),
            // Bouton pour rediriger vers la page d'inscription
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Pas encore de compte ? Inscrivez-vous"),
            ),
            // Nouveau bouton "Mot de passe oublié"
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotPassword');
              },
              child: Text("Mot de passe oublié ?"),
            ),
          ],
        ),
      ),
    );
  }
}
