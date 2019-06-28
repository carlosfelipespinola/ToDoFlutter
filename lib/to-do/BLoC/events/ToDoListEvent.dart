import 'package:to_do_flutter/to-do/models/ToDoList.dart';

import 'Actions.dart';

class ToDoListEvent {
  final Actions action;
  final ToDoList toDoList;

  ToDoListEvent(this.action, this.toDoList);
}