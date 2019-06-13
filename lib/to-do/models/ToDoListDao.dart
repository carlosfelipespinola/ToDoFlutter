import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_flutter/db/AppDatabase.dart';
import 'ToDoList.dart';
import 'ToDoListTableDetails.dart';

class ToDoListDao {
  static Future<int> insert(ToDoList toDoList) async {
    Database dbInstance = await AppDatabase.db.instance;
    return dbInstance.insert(TO_DO_LIST_TABLE_NAME, toDoList.toMap());
  }

  static Future<List<ToDoList>> getAll() async {
    Database dbInstance = await AppDatabase.db.instance;
    var listOfMapToDoList = await dbInstance.query(TO_DO_LIST_TABLE_NAME);
    return listOfMapToDoList.map((toDoListMap) => ToDoList.fromMap(toDoListMap));
  }
}