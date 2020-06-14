import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Scheduler {
  static const MethodChannel _channel = const MethodChannel('scheduler');

  static Future<void> createAndroidChannel(
    String channelId,
    String channelName,
    int channelImportance,
  ) async =>
      await _channel.invokeMethod('createAndroidChannel',
          <dynamic>[channelId, channelName, channelImportance]);

  static Future<void> scheduleNotification(
    TimeOfDay alarmTime,
    String title,
    String text,
  ) async =>
      await _channel.invokeMethod('scheduleNotification', <dynamic>[
        alarmTime.hour,
        alarmTime.minute,
        title,
        text,
      ]);

  static Future<void> cancelNotification() async =>
      await _channel.invokeMethod('cancelNotification', <dynamic>[]);

  static Future<void> cancelNextNotification(TimeOfDay alarmTime) async =>
      await _channel.invokeMethod('cancelNextNotification',
          <dynamic>[alarmTime.hour, alarmTime.minute]);
}
