import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationMessage {
  // Singleton
  static final NotificationMessage _instance = NotificationMessage._internal();
  factory NotificationMessage() => _instance;
  NotificationMessage._internal();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();


  /// Call this once (usually in main.dart before runApp)
  static Future<void> initialize() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
  }

  /// **Ready-to-use function** – just call it anywhere
  static Future<void> showNotification({
    required String title,
    required String message,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel', // channel id
      'Default Channel', // channel name
      channelDescription: 'Main notification channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(id, title, message, platformDetails);
  }
}