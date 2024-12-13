import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesPage extends StatefulWidget {
  final Map<String, dynamic> demandeData;

  MessagesPage({Key? key, required this.demandeData}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = '';
  String userStatus = 'En ligne';
  String userImageUrl = '';
  String userId = ''; // ID utilisateur
  late DocumentReference userRef;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _updateUserStatus(true); // Marque l'utilisateur comme en ligne
  }

  @override
  void dispose() {
    super.dispose();
    _updateUserStatus(false); // Marque l'utilisateur comme hors ligne quand il quitte la page
  }

  Future<void> _getUserInfo() async {
    try {
      // Récupérer l'utilisateur connecté
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          userId = user.uid;
        });

        // Récupérer les données de l'utilisateur depuis Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = '${userData['prenom']} ${userData['nom']}'; // Prénom et Nom
            userImageUrl = userData['imageUrl'] ?? ''; // URL de l'image de profil, si disponible
          });
        }

        // Référence du document utilisateur pour mettre à jour l'état en ligne
        userRef = _firestore.collection('users').doc(user.uid);
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }

  // Mise à jour de l'état en ligne / hors ligne
  Future<void> _updateUserStatus(bool isOnline) async {
    try {
      await userRef.update({
        'isOnline': isOnline,
        'lastSeen': isOnline ? FieldValue.serverTimestamp() : null,
      });
    } catch (e) {
      print('Erreur lors de la mise à jour du statut en ligne : $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _firestore.collection('messages').add({
          'text': _messageController.text.trim(),
          'senderId': userId,
          'senderName': userName,
          'timestamp': FieldValue.serverTimestamp(),
          'cargoType': widget.demandeData['cargoType'],
        });
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi du message : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Demande : ${widget.demandeData['cargoType']}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: userImageUrl.isNotEmpty
                      ? NetworkImage(userImageUrl)
                      : null,
                  child: userImageUrl.isEmpty
                      ? Icon(Icons.person, size: 30)
                      : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : 'Utilisateur',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userStatus,
                        style: TextStyle(
                          color: userStatus == 'En ligne' ? Colors.green : Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          // Affichage des messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('cargoType', isEqualTo: widget.demandeData['cargoType'])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Une erreur s\'est produite.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun message pour le moment.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = messageData['senderId'] == userId;

                    final timestamp = messageData['timestamp'] != null
                        ? (messageData['timestamp'] as Timestamp).toDate()
                        : null;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: isCurrentUser
                                ? Radius.circular(8)
                                : Radius.zero,
                            bottomRight: isCurrentUser
                                ? Radius.zero
                                : Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isCurrentUser)
                              Text(
                                messageData['senderName'] ?? 'Utilisateur',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            Text(
                              messageData['text'] ?? '',
                              style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            if (timestamp != null)
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
