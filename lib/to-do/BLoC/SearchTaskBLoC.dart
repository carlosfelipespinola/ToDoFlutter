
import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:to_do_flutter/to-do/services/TaskServices.dart';

class SearchTaskBloc extends BlocBase {
  TaskServices _taskServices;
  int toDoListUid = -1;

  List<Task> _tasksOfToDoList = [];
  final _tasksController = StreamController<List<Task>>.broadcast();
  StreamSink<List<Task>> get _inTasks => _tasksController.sink;
  Stream<List<Task>> get tasks => _tasksController.stream;

  final _loadToDoListEventController = StreamController<int>();
  StreamSink<int> get addToDoListUidEvent => _loadToDoListEventController.sink;

  SearchTaskBloc() {
    _taskServices = TaskServices();
    this._loadToDoListEventController.stream.listen(_handleAddToDoListUidEvent);
  }

  void _handleAddToDoListUidEvent(int uid) {
    this.toDoListUid = uid;
    _updateTasks();
  }

  void _updateTasks() async {
    _tasksOfToDoList = await _taskServices.getAllTasksFromTodo(toDoListUid);
    _inTasks.add(_tasksOfToDoList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tasksController.close();
    _loadToDoListEventController.close();
    super.dispose();
  }
}