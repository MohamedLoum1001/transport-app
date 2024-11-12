import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() {
    setState(() {
      isLoading = true; // Affiche l'indicateur de chargement
    });

    // Simule une attente pour l'authentification (à remplacer par une vraie logique de connexion)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Cache l'indicateur de chargement
      });

      if (nameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        // Exemple de redirection : transporteur
        Navigator.pushReplacementNamed(context, '/transporterInterface');
        // Pour l'interface client, utilisez : 
        // Navigator.pushReplacementNamed(context, '/clientInterface');
      } else {
        // Affiche une alerte si les champs sont vides
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Erreur"),
            content: Text("Veuillez remplir tous les champs"),
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
    });
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
            isLoading
                ? CircularProgressIndicator() // Affiche le chargement pendant la connexion
                : ElevatedButton(
                    onPressed: loginUser,
                    child: Text('Se connecter'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Pas encore de compte ? Inscrivez-vous"),
            ),
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
