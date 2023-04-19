import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseManager {
  late final FirebaseMessaging? _messaging;
  static FirebaseManager? _instance;

  static FirebaseManager get instance => _instance ??= FirebaseManager._init();

  FirebaseManager._init() {
    _messaging = FirebaseMessaging.instance;
    _init();
  }
  void _init() async {
    NotificationSettings settings = await _messaging!.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationSettings settings = await requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }
    }
    await _messaging!.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  Future<NotificationSettings> requestPermission() async {
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    return settings;
  }
}
