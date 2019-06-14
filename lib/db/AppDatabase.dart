import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_flutter/to-do/models/TaskTableDetails.dart';
import 'package:to_do_flutter/to-do/models/ToDoListTableDetails.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase db = new AppDatabase._();
  static Database _instance;

  Future<Database> get instance async {
    if (_instance != null) {
      return _instance;
    }

    _instance = await initDB();
    return _instance;
  }

  initDB() async {
    String dbsPath = await getDatabasesPath();
    String dbPath = join(dbsPath, 'database.db');
    return openDatabase(dbPath, version: 1, onCreate: _onCreateDb);
  }

  _onCreateDb(Database db, int version) async {
    await db.execute(createToDoListTableSQL);
    await db.execute(createTaskTableSQL);
  }
}