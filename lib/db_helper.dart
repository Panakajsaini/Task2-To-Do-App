import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertTask(String title, String description) async {
    final db = await DBHelper.database();
    await db.insert('tasks', {'title': title, 'description': description});
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await DBHelper.database();
    return db.query('tasks');
  }

  static Future<void> deleteTask(int id) async {
    final db = await DBHelper.database();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
