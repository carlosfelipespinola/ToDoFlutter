
import 'package:to_do_flutter/to-do/models/TaskTableDetails.dart';

class Task {
  int uid;
  String name;
  bool isFinished;
  int toDoUid;

  Task({this.uid, this.name, this.isFinished, this.toDoUid});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uid: map[TASK_UID_FIELD],
      name: map[TASK_NAME_FIELD],
      isFinished: map[TASK_IS_FINISHED_NAME] == 1 ? true : false,
      toDoUid: map[TASK_TO_DO_UID_NAME]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TASK_UID_FIELD: uid,
      TASK_NAME_FIELD: name,
      TASK_IS_FINISHED_NAME: isFinished == true ? 1 : 0,
      TASK_TO_DO_UID_NAME: toDoUid
    };
  }
}