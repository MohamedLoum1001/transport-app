import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchOffers extends StatefulWidget {
  @override
  _SearchOffersState createState() => _SearchOffersState();
}

class _SearchOffersState extends State<SearchOffers> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Méthode pour filtrer les offres selon la recherche
  void _filterOffers(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche d\'offres', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent, // AppBar color
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: OfferSearchDelegate(),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterOffers,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Rechercher une offre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('offers')
                  .where('description', isGreaterThanOrEqualTo: _searchQuery)
                  .where('description', isLessThan: _searchQuery + 'z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Aucune offre disponible."));
                }

                final offers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: ListTile(
                        title: Text(offer['description'] ?? "Sans description", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date : ${offer['date'] ?? "Non spécifiée"}"),
                            Text("Statut : ${offer['status'] ?? "Non spécifié"}"),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
                        onTap: () {
                          // Action supplémentaire sur l'offre si nécessaire
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Détails de l'offre", style: TextStyle(fontWeight: FontWeight.bold)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Description : ${offer['description'] ?? "Non spécifiée"}"),
                                  Text("Date : ${offer['date'] ?? "Non spécifiée"}"),
                                  Text("Statut : ${offer['status'] ?? "Non spécifié"}"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Fermer", style: TextStyle(color: Colors.deepPurpleAccent)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OfferSearchDelegate extends SearchDelegate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('offers').where('description', isGreaterThanOrEqualTo: query).where('description', isLessThan: query + 'z').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Aucune offre trouvée."));
        }

        final offers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return ListTile(
              title: Text(offer['description'] ?? "Sans description", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Date : ${offer['date'] ?? "Non spécifiée"}"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Détails de l'offre", style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Description : ${offer['description'] ?? "Non spécifiée"}"),
                        Text("Date : ${offer['date'] ?? "Non spécifiée"}"),
                        Text("Statut : ${offer['status'] ?? "Non spécifié"}"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Fermer", style: TextStyle(color: Colors.deepPurpleAccent)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
