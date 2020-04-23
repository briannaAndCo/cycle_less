import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Import tables
import 'pressed_pill.dart';

void createDatabase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'pill_reminder_database.db'),

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

Future<void> insertPressedPill(PressedPill pill) async {
  final Database db = await _retrieveDatabase();

  await db.insert(
    'pressed_pill',
    pill.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deletePressedPill(int id) async {
  final Database db = await _retrieveDatabase();

  // Remove the Dog from the Database.
  await db.delete(
    'pressed_pill',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<PressedPill>> retrievePressedPills(maxRetrieve) async {
  final Database db = await _retrieveDatabase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('pressed_pill', distinct: true, orderBy: 'date desc', limit: maxRetrieve );

  // Convert the List<Map<String, dynamic> into a List<Dog>.
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



Future<Database> _retrieveDatabase() async {
  final database =
      openDatabase(join(await getDatabasesPath(), 'pill_reminder_database.db'));
  return database;
}
