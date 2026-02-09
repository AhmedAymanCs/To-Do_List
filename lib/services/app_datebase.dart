import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  static Database? _db;
  static Future<Database> get datebase async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  } //check if database is already initialized, if not initialize it and return the instance

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE tasks
          (id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT, 
           isCompleted INTEGER, 
           dueDate TEXT)''');
      },
    );
  }
}
