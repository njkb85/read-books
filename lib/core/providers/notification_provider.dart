import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  bool _enabled = true;
  bool get enabled => _enabled;

  NotificationProvider() {
    _loadSetting();
    _initMessaging();
  }

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('notifications') ?? true;
    notifyListeners();
  }

  Future<void> _initMessaging() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await messaging.getToken();
    print('FCM Token: $token');
    if (token != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'fcmToken': token});
      }
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificacion: ${message.notification?.title}');
    });
  }

  Future<void> toggleNotifications(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('all');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('all');
    }
    notifyListeners();
  }
}
