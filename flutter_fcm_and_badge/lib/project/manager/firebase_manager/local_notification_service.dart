part of 'firebase_manager.dart';

class LocaleNotificationService {
  static LocaleNotificationService? _instance;
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

    await _localNotificationsPlugin.show(
      id,
      message.data['title'],
      message.data['body'],
      notificationDetails,
      payload: message.data['payload'],
    );
  }

  Future<void> init() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fcm', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
