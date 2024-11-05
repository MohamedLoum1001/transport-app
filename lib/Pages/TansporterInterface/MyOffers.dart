// screens/my_offers.dart
import 'package:flutter/material.dart';

class MyOffersDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Offres")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Liste de vos offres"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique pour ajouter une nouvelle offre
              },
              child: Text("Ajouter une offre"),
            ),
          ],
        ),
      ),
    );
  }
}
