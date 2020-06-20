import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pill_reminder/data/pressed_pill.dart';
import 'package:pill_reminder/model/pill_package_model.dart';
import 'dart:math';
import 'package:pill_reminder/widgets/protection.dart';

void main() {
  testWidgets(
      'State should be protected since 21 pills have been taken; No break taken',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getValidContinuousUse21of28NoBreakYet(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder =
        find.text('A seven day break from active pills\nmay be taken any time.');

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected since 21 pills have been taken; in day 7 of break from pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getValidContinuousUse21of28OnBreakNoRemaining(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder =
        find.text('To maintain protection, resume active pills.');

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected since 21 pills have been taken; in day 5 of break from pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getValidContinuousUse21of28OnBreak(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder = find.text('There are two protected days remaining.');

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since the last pill taken was 48 hours earlier; in active pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getInvalidTimeElapsedValid21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be unprotected since there is 3 late pills in 17 days; in active pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getInvalidPills3Time21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Unprotected');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be compromised since there is 2 late pills in 23 days; in active pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getCompromisedPills2Time24of28InActive(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Compromised');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be compromised since there is 2 late pills in 17 days; in active pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getCompromisedPills2Time21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Compromised');

    expect(protectionFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected but not breakable since there is 1 late pill in 9 days; in active pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getCompromisedPills1Time21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder = find.text("Continue active pills to maintain protection.");

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      'State should be compromised since there are 2 late pills in the 21 days; currently starting placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _getCompromisedTime21of28InPlacebo(),
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
            pillPackageModel: _getLatePillsTime21of28InPlacebo(),
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
            pillPackageModel: _getInvalidAmount21of28InPlacebo(),
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
            pillPackageModel: _getInvalidTime21of28InPlacebo(),
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
            pillPackageModel: _getInvalidTime21of28InActive(),
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
            pillPackageModel: _getInvalidAmount21of28InActive(),
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
            pillPackageModel: _get21of28InPlacebo(),
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
            pillPackageModel: _getInvalidLate21of28InActive(),
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
            pillPackageModel: _get21of28LastActiveTaken(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder = find.text('Continue active pills to maintain protection.');

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      '1State should be protected with 21 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _get21of28LastActiveTaken(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder =
        find.text('A seven day break from active pills\nmay be taken any time.');

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      '2State should be protected with 24 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _get24of28InPlacebo(),
            totalWeeks: 4,
            placeboDays: 4,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder = find.text("There are 24 hours protected remaining.");

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      '3State should be protected with 21 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _get21of28InPlaceboNoMore(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');
    final reasonFinder =
        find.text("To maintain protection, resume active pills.");

    expect(protectionFinder, findsOneWidget);
    expect(reasonFinder, findsOneWidget);
  });

  testWidgets(
      'State should be protected with 21 valid pills; currently in placebo',
      (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Protection(
            pillPackageModel: _get21of28InPlacebo(),
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
            pillPackageModel: _getValid21of28InActive(),
            totalWeeks: 4,
            placeboDays: 7,
            isMiniPill: false)));
    final protectionFinder = find.text('Protected');

    expect(protectionFinder, findsOneWidget);
  });
}

PillPackageModel _getValid21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _get21of28InPlacebo() {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

// Create a list of pressed pills where there are placebos in the end and
// the beginning but all actives are correctly taken
PillPackageModel _getMiddle21of28InPlacebo() {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _get21of28LastActiveTaken() {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _get24of28InPlacebo() {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _get21of28InPlaceboNoMore() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 28; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    date = date.subtract(Duration(days: 1, hours: 5));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidAmount21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 6; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidTime21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: 14));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidTime21of28InPlacebo() {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidAmount21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = false;
  for (int i = 23; i >= 1; i--) {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getCompromisedTime21of28InPlacebo() {
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
    if (i == 2 || i == 20) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getLatePillsTime21of28InPlacebo() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(hours: 12));
  Random generator = Random();
  bool active = false;
  for (int i = 22; i >= 1; i--) {
    //After pill 21 they become active.
    if (i <= 21) {
      active = true;
    }

    list.add(PressedPill(id: null, day: i, date: date, active: active));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing
    if (i == 2 || i == 12) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidLate21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(days: 2));
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: 14));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getCompromisedPills1Time21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 9; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 2) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getCompromisedPills2Time21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 17; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 2 || i == 15) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getCompromisedPills2Time24of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 23; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 15 || i == 22) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidPills3Time21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  for (int i = 17; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    int hour = generator.nextInt(12);
    //Create 2 days with bad timing. This should make the protection compromised
    if (i == 2 || i == 15 || i == 17) {
      hour = 15;
    }

    date = date.subtract(Duration(days: 1, hours: hour));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

PillPackageModel _getInvalidTimeElapsedValid21of28InActive() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(days: 2));
  Random generator = Random();
  for (int i = 8; i >= 1; i--) {
    list.add(PressedPill(id: null, day: i, date: date, active: true));

    date = date.subtract(Duration(days: 1, hours: generator.nextInt(12)));
  }

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

// Create a list of pressed pills where a break is taken in the middle of the
// pack but 21 valid pills have been taken
PillPackageModel _getValidContinuousUse21of28OnBreak() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(days: 5));
  Random generator = Random();
  bool active = true;
  int day = 14;
  for (int i = 28; i >= 1; i--) {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

// Create a list of pressed pills where a break is taken in the middle of the
// pack but 21 valid pills have been taken
PillPackageModel _getValidContinuousUse21of28OnBreakNoRemaining() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now().subtract(Duration(days: 7));
  Random generator = Random();
  bool active = true;
  int day = 14;
  for (int i = 28; i >= 1; i--) {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}

// Create a list of pressed pills where 21 valid pills have been taken
// but no break has been taken.
PillPackageModel _getValidContinuousUse21of28NoBreakYet() {
  List<PressedPill> list = new List();

  DateTime date = DateTime.now();
  Random generator = Random();
  bool active = true;
  int day = 14;
  for (int i = 28; i >= 1; i--) {
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

  PillPackageModel model = PillPackageModel();
  model.setLoadedPressedPills(list);
  return model;
}
