// screens/my_transports.dart
import 'package:flutter/material.dart';

class MyTransportsDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Transports")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Historique et transports en cours"),
            SizedBox(height: 20),
            // Logique pour afficher les transports
            ElevatedButton(
              onPressed: () {
                // Logique pour mettre à jour l'état d'un transport
              },
              child: Text("Mettre à jour un transport"),
            ),
          ],
        ),
      ),
    );
  }
}
