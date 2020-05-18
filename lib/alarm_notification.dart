import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const ANDROID_CHANNEL_DESC = "Pill reminder application for birth control.";
const ANDROID_CHANNEL_ID = "Pill Reminder";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final MethodChannel platform =
    MethodChannel('crossingthestreams.io/resourceResolver');

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
//final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//   BehaviorSubject<ReceivedNotification>();

//final BehaviorSubject<String> selectNotificationSubject =
//   BehaviorSubject<String>();
class AlarmNotification {
  static AlarmNotification _alarmNotification;

  NotificationAppLaunchDetails notificationAppLaunchDetails;

  AlarmNotification();

  void _initialize() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showDailyAtTime(TimeOfDay time) async {
    // this calls a method over a platform channel implemented within the example app to return the Uri for the default
    // alarm sound and uses as the notification sound
    //String alarmUri = await platform.invokeMethod('getAlarmUri');
    //final x = UriAndroidNotificationSound(alarmUri);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        ANDROID_CHANNEL_ID, ANDROID_CHANNEL_ID, ANDROID_CHANNEL_DESC,
        playSound: true, styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: null);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        1,
        'Pill Reminder',
        'Take your pill.',
        Time(time.hour, time.minute, 0),
        platformChannelSpecifics);
  }

  static void setNotification(TimeOfDay timeOfDay) {
    _get()._showDailyAtTime(timeOfDay);
  }

  static Future<void> stopCurrentNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  static AlarmNotification _get() {
    if (_alarmNotification == null) {
      _alarmNotification = AlarmNotification();
      _alarmNotification._initialize();
    }
    return _alarmNotification;
  }
}
