import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint("Notification clicked: ${response.payload}");
    });
  }

  static Future<void> scheduleNotificationAt(
      tz.TZDateTime scheduledTime, int id,
      {String? title, String? body}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title ?? 'Workout Schedule',
        body ?? 'It\'s time to work out, let\'s get started',
        scheduledTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'exercise_channel', 'Exercise Notifications',
                channelDescription: 'Notifcation Workout',
                importance: Importance.max,
                priority: Priority.high)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: null,
        payload: 'exercise_reminder');
  }

  static Future<void> showNotification(int id,
      {String? title, String? body}) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'New Notfication',
      body ?? 'You have new a notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'exercise_channel',
          'Exercise Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<bool> checkExactAlarmPermission() async {
    if (Platform.isAndroid && Platform.version.compareTo('12') >= 0) {
      const platform = MethodChannel('alarm_channel');
      final result =
          await platform.invokeMethod<bool>('canScheduleExactAlarms');
      return result ?? false;
    }
    return true;
  }

  Future<void> requestExactAlarmPermission() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  }

  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      if (!await Permission.notification.isGranted) {
        final status = await Permission.notification.request();
        return status.isGranted;
      }
      return true;
    }
    return true;
  }
}
