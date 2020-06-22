import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'pressed_pill.dart';

void createDatabase() async {
  final database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'dosettebox_database.db'),

    onCreate: (db, version) {
      return db.execute(
        PressedPill.createTableDB,
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<int> insertOrUpdatePressedPill(PressedPill pill) async {
  final Database db = await _retrieveDatabase();

  int newId = await db.insert(
    'pressed_pill',
    pill.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return newId;
}

Future<void> deletePressedPill(int id) async {
  final Database db = await _retrieveDatabase();

  // Remove the pressed pill from the database.
  await db.delete(
    'pressed_pill',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<PressedPill>> retrievePressedPills(maxRetrieve) async {
  final Database db = await _retrieveDatabase();

  final List<Map<String, dynamic>> maps = await db.query('pressed_pill',
      distinct: true, orderBy: 'date desc', limit: maxRetrieve);

  // Convert the List<Map<String, dynamic> into a List<PressedPill>.
  return List.generate(maps.length, (i) {
    bool isActive = maps[i]['active'] != 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(maps[i]['date']);

    return PressedPill(
      id: maps[i]['id'],
      day: maps[i]['day'],
      date: date,
      active: isActive,
    );
  });
}

Future<void> deleteAllPressedPills() async {
  final Database db = await _retrieveDatabase();

  await db.delete('pressed_pill');
}

Future<Database> _retrieveDatabase() async {
  final database =
      openDatabase(join(await getDatabasesPath(), 'dosettebox_database.db'));
  return database;
}
