import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pill_reminder/data/pressed_pill.dart';
import 'dart:math';
import 'package:pill_reminder/widgets/protection.dart';

void main() {


  testWidgets('State should be protected for 2 days of mini pills', (WidgetTester tester) async {
    await tester.pumpWidget( Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: getValidMiniPills(),
            totalWeeks: 4,
            placeboDays: 0,
            isMiniPill: true)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets('State should be unprotected for 1 days of mini pills', (WidgetTester tester) async {
    await tester.pumpWidget( Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: getInvalidAmountMiniPills(),
            totalWeeks: 4,
            placeboDays: 0,
            isMiniPill: true)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets('State should be unprotected for 2 days with invalid times of mini pills', (WidgetTester tester) async {
    await tester.pumpWidget( Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: getInvalidTimeMiniPills(),
            totalWeeks: 4,
            placeboDays: 0,
            isMiniPill: true)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });
}

List<PressedPill> getValidMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 2; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(2)));
  }

  return list;
}

List<PressedPill> getInvalidAmountMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 1; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(2)));
  }

  return list;
}

List<PressedPill> getInvalidTimeMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 2; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: 4));
  }

  return list;
}