import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pill_reminder/data/pressed_pill.dart';
import 'dart:math';
import 'package:pill_reminder/widgets/protection.dart';

void main() {

  testWidgets(
      'State should be compromised since there are 2 late pills in the 21 days; currently starting placebo',
          (WidgetTester tester) async {
        await tester.pumpWidget(Directionality(
            textDirection: TextDirection.ltr,
            child: Protection(
                pressedPills: _getCompromisedTime21of28InPlacebo(),
                totalWeeks: 4,
                placeboDays: 7,
                isMiniPill: false)));
        final protectionFinder = find.text('Compromised');

        expect(protectionFinder, findsOneWidget);
      });

  testWidgets(
      'State should be unprotected since there are 2 late pills in the 21 days; in placebo',
          (WidgetTester tester) async {
        await tester.pumpWidget(Directionality(
            textDirection: TextDirection.ltr,
            child: Protection(
                pressedPills: _getLatePillsTime21of28InPlacebo(),
                totalWeeks: 4,
                placeboDays: 7,
                isMiniPill: false)));
        final protectionFinder = find.text('Unprotected');

        expect(protectionFinder, findsOneWidget);
      });

  testWidgets(
      'State should be unprotected since there is a skipped pill in the 21 days; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _getInvalidAmount21of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since the times are invalid for 3 of the 21 days; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _getInvalidTime21of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since the times are invalid for the last 7 days; currently in active',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _getInvalidTime21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since they have less than 7 pills taken; currently in active',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _getInvalidAmount21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unproteced with 21 pills out of 24 required; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _get21of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since it the last pill is over the time limit',
          (WidgetTester tester) async {
        await tester.pumpWidget(Directionality(
            textDirection: TextDirection.ltr,
            child: Protection(
                pressedPills: _getInvalidLate21of28InActive(),
                totalWeeks: 4,
                placeboDays: 4,
                isMiniPill: false)));
        final protectionFinder = find.text('Unprotected');

        expect(protectionFinder, findsOneWidget);
      });

  testWidgets(
      'State should be protected with 21 pills out of 24 required; currently in active',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _get21of28LastActiveTaken(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected with 21 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _get21of28LastActiveTaken(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected with 24 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _get24of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected with 21 valid pills; currently in placebo',
          (WidgetTester tester) async {
        await tester.pumpWidget(Directionality(
            textDirection: TextDirection.ltr,
            child: Protection(
                pressedPills: _getMiddle21of28InPlacebo(),
                totalWeeks: 4,
                placeboDays: 7,
                isMiniPill: false)));
        final protectionFinder = find.text('Protected');

        expect(protectionFinder, findsOneWidget);
      });

  testWidgets(
      'State should be protected with 21 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _get21of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets('State should be protected for 7 valid days',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pressedPills: _getValid21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });
}

List<PressedPill> _getValid21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

List<PressedPill> _get21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 24; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

// Create a list of pressed pills where there are placebos in the end and
// the beginning but all actives are correctly taken
List<PressedPill> _getMiddle21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  int day = 23;
  for (int i = 28; i >= -4; i--) {
    //After pill 21 they become active.
    if (i <= 21 && i >= 1) {
      active = true;
    } else {
      active = false;
    }

    if (i <= 28 && i >= 1) {
      day--;
    }
    if (i == 0) {
      day = 28;
    }
    if (i < 0) {
      day--;
    }

    list.add(PressedPill(id: null, day: day, date: date, active: active));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

List<PressedPill> _get21of28LastActiveTaken() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 21; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

List<PressedPill> _get24of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 27; i >= 1; i--) {
    //After pill 23 they become active.
    if (i <= 24) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

List<PressedPill> _getInvalidAmount21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 6; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}

List<PressedPill> _getInvalidTime21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: 14));
  }

  return list;
}

List<PressedPill> _getInvalidTime21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 21; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    int hour = generator.nextInt(12);
    //Create three days with bad timing. This should make the protection unprotected
    if (i == 2 || i == 12 || i == 20) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  return list;
}

List<PressedPill> _getInvalidAmount21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 21; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    //Skip an active day. This should make the protection invalid
    if (i == 2) {
      break;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    int hour = generator.nextInt(12);

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  return list;
}

List<PressedPill> _getCompromisedTime21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 21; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 2 || i == 12) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  return list;
}

List<PressedPill> _getLatePillsTime21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 22; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 2 || i == 12) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  return list;
}

List<PressedPill> _getInvalidLate21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(days:2));
  Random generator = Random();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  return list;
}
