import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:to_do_flutter/to-do/models/ToDoListDao.dart';

class ToDoListServices {

  Future<int> insertNewTodoList(ToDoList toDoList) async {
    return ToDoListDao.insert(toDoList);
  }

  Future<List<ToDoList>> getAllToDoLists() async {
    return ToDoListDao.getAll();
  }

}