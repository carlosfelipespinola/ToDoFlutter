import 'package:to_do_flutter/to-do/models/ToDoList.dart';

enum Actions { insert, delete }

class ToDoListEvent {
  final Actions action;
  final ToDoList toDoList;

  ToDoListEvent(this.action, this.toDoList);
}