import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Méthode pour se connecter avec Firebase
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("Veuillez remplir tous les champs");
      return;
    }

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(emailController.text)) {
      showErrorDialog("Veuillez entrer un email valide");
      return;
    }

    setState(() {
      isLoading = true; // Affiche l'indicateur de chargement
    });

    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Récupère le type d'utilisateur depuis Firestore (ex: "Client" ou "Transporteur")
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String userType = userDoc.data()?['type'] ?? 'Client'; // Par défaut, "Client"

      setState(() {
        isLoading = false;
      });

      // Redirige en fonction du type d'utilisateur
      if (userType == 'Transporteur') {
        Navigator.pushReplacementNamed(context, '/transporterInterface');
      } else {
        Navigator.pushReplacementNamed(context, '/clientInterface');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog("Erreur de connexion : ${e.toString()}");
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
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator() // Affiche l'indicateur de chargement
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
