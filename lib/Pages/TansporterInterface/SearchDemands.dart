// screens/search_demands.dart
import 'package:flutter/material.dart';

class SearchDemandsDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rechercher des demandes")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Rechercher des demandes de transport"),
            SizedBox(height: 20),
            // Vous pouvez ajouter un champ de recherche ici
            ElevatedButton(
              onPressed: () {
                // Logique pour lancer la recherche
              },
              child: Text("Lancer la recherche"),
            ),
          ],
        ),
      ),
    );
  }
}
