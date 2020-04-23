class PressedPill {
  final int id;
  final DateTime date;
  final int day;
  final bool active;

  PressedPill({this.id, this.date, this.day, this.active});

  @override
  String toString() {
    return "PressedPill{id: $id, date: $date, day: $day, active: $active}";
  }

  Map<String, dynamic> toMap() {
    int isActive = active ? 1 : 0;
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'day': day,
      'active': isActive
    };
  }

  static const String createTableDB = "CREATE TABLE IF NOT EXISTS "
      "pressed_pill("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "date INTEGER, "
      "day INTEGER, "
      "active INTEGER)";
}
