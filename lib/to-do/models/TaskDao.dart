import 'dart:async';

import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_flutter/db/AppDatabase.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:to_do_flutter/to-do/models/TaskTableDetails.dart';

class TaskDao {

  static Future<int> insert(Task task, {bool autoGeneratedUid: true}) async {
    Database dbInstance = await AppDatabase.db.instance;
    var map = task.toMap();
    if(autoGeneratedUid && map[TASK_UID_FIELD] == null) {
      map.remove(TASK_UID_FIELD);
    }
    return dbInstance.insert(TASK_TABLE_NAME, map);
  }

  static Future<int> update(Task task) async {
    Database dbInstance = await AppDatabase.db.instance;
    return dbInstance.update(
      TASK_TABLE_NAME,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: '$TASK_UID_FIELD = ?', whereArgs: [task.uid]
    );
  }

  static Future<int> delete(Task task) async {
    Database dbInstance = await AppDatabase.db.instance;
    return dbInstance.delete(TASK_TABLE_NAME, where: '$TASK_UID_FIELD = ?', whereArgs: [task.uid]);
  }

  static Future<List<Task>> getAllTasksFromToDoList(int toDoUid) async {
    Database dbInstance = await AppDatabase.db.instance;
    var sql = 'select * from $TASK_TABLE_NAME where $TASK_TO_DO_UID_NAME = $toDoUid';
    var listOfMapToDoList = await dbInstance.rawQuery(sql);
    return listOfMapToDoList.map((toDoListMap) => Task.fromMap(toDoListMap)).toList();
  }

  static Future<List<Task>> getTasksFromToDoListBySearch(int toDoUid, String search) async {
    Database dbInstance = await AppDatabase.db.instance;
    var sql = 'select * from $TASK_TABLE_NAME where $TASK_TO_DO_UID_NAME = $toDoUid and $TASK_NAME_FIELD like "%$search%"';
    var listOfMapToDoList = await dbInstance.rawQuery(sql);
    return listOfMapToDoList.map((toDoListMap) => Task.fromMap(toDoListMap)).toList();
  }

}