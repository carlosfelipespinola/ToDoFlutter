
import 'ToDoListTableDetails.dart';

class ToDoList {
  int uid;
  String name;
  double percentage;

  ToDoList({this.uid, this.name, this.percentage});

  factory ToDoList.fromMap(Map<String, dynamic> map) {
    return ToDoList(
      uid: map[UID_FIELD],
      name: map[NAME_FIELD],
      percentage: map['percentage']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UID_FIELD: this.uid,
      NAME_FIELD: this.name,
    };
  }
}