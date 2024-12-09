import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tranport_app/Components/Boutons/boutonReutilisable.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = false;

  // Méthode pour se connecter avec Firebase
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("Veuillez remplir tous les champs");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(emailController.text)) {
      showErrorDialog("Veuillez entrer un email valide");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String userType = userDoc.data()?['type'] ?? 'Client';

      setState(() {
        isLoading = false;
      });

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

  // Méthode pour afficher la boîte de dialogue d'erreur
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
            // Champ email avec style personnalisé
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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

            // Champ mot de passe avec style personnalisé
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
              obscureText: !passwordVisible,
            ),
            SizedBox(height: 20),

            // Bouton de connexion avec le composant bouton réutilisable
            isLoading
                ? CircularProgressIndicator()
                : BoutonReutilisable(
                    onPressed: loginUser,
                    text: 'Se connecter', // Utilisez 'text' au lieu de 'child'
                    backgroundColor: Colors.purple,  // Couleur d'arrière-plan
                    textColor: Colors.white,         // Couleur du texte
                  ),

            // Lien vers la page d'inscription
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Pas encore de compte ? Inscrivez-vous",
                style: TextStyle(color: Colors.purple),
              ),
            ),

            // Lien vers la page de mot de passe oublié
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotPassword');
              },
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
