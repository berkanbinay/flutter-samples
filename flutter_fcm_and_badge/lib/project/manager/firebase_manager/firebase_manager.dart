import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'local_notification_service.dart';

class FirebaseManager {
  static FirebaseManager? _instance;
  static FirebaseMessaging? _messaging;

  FirebaseManager._() {
    _messaging = FirebaseMessaging.instance;
  }

  static FirebaseManager get instance => _instance ??= FirebaseManager._();

  void init() async {
    NotificationSettings settings = await _messaging!.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationSettings settings = await _requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }
    }
    await _messaging!.subscribeToTopic('all');
    LocaleNotificationService.instance.init();
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    // TODO: fix background message
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    if (message.notification != null) {
      log('Foreground Handler: ${message.notification?.body}');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      log('Background Handler: ${message.notification?.body}');
    }
  }

  Future<NotificationSettings> _requestPermission() async {
    NotificationSettings settings = await _messaging!.requestPermission(
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
