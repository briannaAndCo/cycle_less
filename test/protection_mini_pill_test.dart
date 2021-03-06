import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cycleless/data/pressed_pill.dart';
import 'package:cycleless/model/pill_package_model.dart';
import 'dart:math';
import 'package:cycleless/widgets/protection.dart';

void main() {


  testWidgets('State should be protected for 2 days of mini pills', (WidgetTester tester) async {
    await tester.pumpWidget( Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: getValidMiniPills(),
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
            pillPackageModel: getInvalidAmountMiniPills(),
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
            pillPackageModel: getInvalidTimeMiniPills(),
            totalWeeks: 4,
            placeboDays: 0,
            isMiniPill: true)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets('State should be unprotected for late taken mini pill', (WidgetTester tester) async {
    await tester.pumpWidget( Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: getInvalidLateMiniPills(),
            totalWeeks: 4,
            placeboDays: 0,
            isMiniPill: true)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

}

PillPackageModel getValidMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 3; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(2)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel getInvalidAmountMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 2; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(2)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel getInvalidTimeMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  for (int i = 3; i >=1; i-- ) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: 4));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}
PillPackageModel getInvalidLateMiniPills() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  date = date.subtract(Duration(days: 2));
  Random generator = Random();
  for (int i = 3; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(2)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}
