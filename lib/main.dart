import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(title: 'Pill Reminder'),
    );
  }
}