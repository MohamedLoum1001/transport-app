import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Demander les autorisations pour les notifications (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission accordée !');
    } else {
      print('Permission refusée.');
    }

    // Obtenir le token FCM de l'appareil
    String? token = await _messaging.getToken();
    print("Token FCM : $token");

    // Écouter les messages en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan : ${message.notification?.title}');
      // Gérer l'affichage de la notification (snackbar, dialogue, etc.)
    });

    // Écouter les messages lorsque l'utilisateur clique sur une notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification ouverte par l\'utilisateur.');
      // Naviguer vers une page spécifique, si nécessaire
    });
  }
}
