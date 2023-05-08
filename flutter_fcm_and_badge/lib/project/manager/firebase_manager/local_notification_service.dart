part of 'firebase_manager.dart';

class LocaleNotificationService {
  static late final LocaleNotificationService? _instance;
  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  LocaleNotificationService._() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  static LocaleNotificationService get instance =>
      _instance ??= LocaleNotificationService._();

  Future<void> display(RemoteMessage message) async {
    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'fcm',
        'fcm',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      inspect(message);
      await _localNotificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'payload',
      );
    } catch (e) {
      await _localNotificationsPlugin.cancel(id);
    }
  }

  Future<void> init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) {},
      ),
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fcm', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
