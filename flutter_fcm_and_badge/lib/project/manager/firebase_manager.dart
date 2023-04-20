import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseManager {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static void init() async {
    NotificationSettings settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationSettings settings = await _requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }
    }
    await _messaging.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification!.body}');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification!.body}');
    }
  }

  static Future<NotificationSettings> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
    return settings;
  }
}
