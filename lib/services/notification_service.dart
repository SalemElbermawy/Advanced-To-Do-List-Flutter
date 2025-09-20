import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات
  Future<void> initializeNotification() async {
    tz.initializeTimeZones(); 

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/notif_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        await selectNotification(response.payload);
      },
    );
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> requestAndroidPermissions() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      debugPrint("Android notification permission granted: $granted");
    }
  }

  Future<void> requestExactAlarmsPermission() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestExactAlarmsPermission();
      debugPrint("Exact alarms permission granted: $granted");
    }
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    } else {
      debugPrint("Notification Done");
    }
    Get.to(() => Container(color: Colors.white));
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'theme_channel_id',
      'Theme Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/notif_icon',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    debugPrint("doing test");

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'theme_channel_id',
      'Theme Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/notif_icon',
    );
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Theme changed',
    );
  }

  Future<void> scheduledNotification() async {
    final androidDetails = AndroidNotificationDetails(
      'scheduled_channel_id',
      'Scheduled Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/notif_icon',
    );
    final iOSDetails = DarwinNotificationDetails();

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Title',
      'Theme changed 5 seconds ago',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
