import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> showRateAlert({
    required String baseCurrency,
    required String targetCurrency,
    required double currentRate,
    required double thresholdRate,
    required bool isAbove,
  }) async {
    if (!_initialized) await initialize();

    final title = 'Rate Alert';
    final message = '${baseCurrency}/${targetCurrency} rate is now ' +
        (isAbove ? 'above' : 'below') +
        ' $thresholdRate (Current: $currentRate)';

    const androidDetails = AndroidNotificationDetails(
      'rate_alerts',
      'Rate Alerts',
      channelDescription: 'Currency rate alerts notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      message,
      notificationDetails,
    );
  }
}