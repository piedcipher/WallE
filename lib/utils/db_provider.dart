import 'package:sqflite/sqflite.dart';
import 'package:walle/utils/contants.dart';

class DatabaseProvider {
  static Database _database;
  static String _databasePath;

  static Future open() async {
    _databasePath = await getDatabasesPath() + 'walle.db';
    _database = await openDatabase(_databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $kTable
          (id INTEGER PRIMARY KEY autoincrement, pid TEXT, urls_raw TEXT,
          links_html TEXT, urls_regular TEXT, name TEXT, location TEXT,
          height INTEGER, width INTEGER, likes INTEGER, created_at TEXT)''');
    });
    return _database;
  }
}
