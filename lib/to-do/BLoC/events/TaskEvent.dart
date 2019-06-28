


import 'package:to_do_flutter/to-do/models/Task.dart';

import 'Actions.dart';

class TaskEvent {
  final Actions action;
  final Task task;

  TaskEvent(this.action, this.task);
}