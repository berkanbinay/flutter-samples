import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'local_notification_service.dart';

class FirebaseManager {
  static FirebaseManager? _instance;
  FirebaseMessaging? _messaging;

  FirebaseManager._() {
    _messaging = FirebaseMessaging.instance;
  }

  static FirebaseManager get instance => _instance ??= FirebaseManager._();

  void init() async {
    log('FCM Token: ${await _messaging!.getToken()}');

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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _firebaseMessagingForegroundHandler(RemoteMessage message) {
    log('Foreground Handler: ${message.data['body']}');
    LocaleNotificationService.instance.display(message);
  }

  Future<NotificationSettings> _requestPermission() async {
    NotificationSettings settings = await _messaging!.requestPermission();
    log('User granted permission: ${settings.authorizationStatus}');
    return settings;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background Handler: ${message.data['body']}');
}
