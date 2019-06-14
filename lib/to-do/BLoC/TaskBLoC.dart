import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:to_do_flutter/to-do/services/TaskServices.dart';
import 'package:to_do_flutter/to-do/services/ToDoListServices.dart';
import 'dart:async';

class TaskBloc extends BlocBase {
  TaskServices _taskServices;
  int toDoListUid = -1;

  List<Task> _tasksOfToDoList = [];
  final _tasksController = StreamController<List<Task>>.broadcast();
  StreamSink<List<Task>> get _inTasks => _tasksController.sink;
  Stream<List<Task>> get tasks => _tasksController.stream;

  final _tasksEventController = StreamController<Task>();
  StreamSink<Task> get addTaskEvent => _tasksEventController.sink;

  final _loadToDoListEventController = StreamController<int>();
  StreamSink<int> get addToDoListUidEvent => _loadToDoListEventController.sink;

  TaskBloc() {
    _taskServices = TaskServices();
    this._loadToDoListEventController.stream.listen(_handleAddToDoListUidEvent);
    this._tasksEventController.stream.listen(_handleAddTaskEvent);
  }

  void _handleAddToDoListUidEvent(int uid) {
    this.toDoListUid = uid;
    print(toDoListUid);
    this._taskServices.getAllTasksFromTodo(this.toDoListUid)
    .then((tasks) {
      _tasksOfToDoList = tasks;
      print(_tasksOfToDoList);
      _inTasks.add(_tasksOfToDoList);
    })
    .catchError((error) => {});
  }

  void _handleAddTaskEvent(Task task) async {
    _taskServices.insertNewTask(task);
    _tasksOfToDoList = await _taskServices.getAllTasksFromTodo(toDoListUid);
    _inTasks.add(_tasksOfToDoList);
  }

  @override
  void dispose() {
    _tasksEventController.close();
    _tasksController.close();
    _loadToDoListEventController.close();
    super.dispose();
  }
}