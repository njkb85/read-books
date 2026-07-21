import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await _messaging.getToken();
    print('FCM Token: ');

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(const InitializationSettings(android: android));

    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message.notification?.title ?? '', message.notification?.body ?? '');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notificacion abierta: ');
    });
  }

  void _showLocalNotification(String title, String body) {
    _local.show(DateTime.now().millisecond, title, body, const NotificationDetails(android: AndroidNotificationDetails('read_channel', 'READ Notifications', importance: Importance.high, priority: Priority.high)));
  }
}
