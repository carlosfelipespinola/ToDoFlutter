import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:to_do_flutter/to-do/models/ToDoListDao.dart';

class ToDoListServices {

  Future<int> insertNewTodoList(ToDoList toDoList) async {
    if (toDoList.name == null) {
      throw Exception('A To-Do List must have a name');
    }
    if (toDoList.uid != null) {
      throw Exception('When inserting a To-Do List the uid must be null');
    }
    return ToDoListDao.insert(toDoList, autoGeneratedUid: true);
  }

  Future<List<ToDoList>> getAllToDoLists() async {
    return ToDoListDao.getAll();
  }

  Future<int> deleteToDoList(ToDoList toDoList) async {
    return ToDoListDao.deleteToDoList(toDoList);
  }

  Future<int> updateToDoList(ToDoList toDoList) async {
    return ToDoListDao.updateToDoList(toDoList);
  }
}