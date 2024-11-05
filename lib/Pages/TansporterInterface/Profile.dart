// screens/profile.dart
import 'package:flutter/material.dart';

class ProfileDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Votre profil"),
            SizedBox(height: 20),
            // Champs de profil
            TextField(
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Téléphone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique pour mettre à jour le profil
              },
              child: Text("Mettre à jour le profil"),
            ),
          ],
        ),
      ),
    );
  }
}
