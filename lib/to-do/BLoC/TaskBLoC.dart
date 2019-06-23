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

  final _tasksSearchController = StreamController<String>.broadcast();
  StreamSink<String> get inSearchTask => _tasksSearchController.sink;

  final _tasksProgressController = StreamController<double>.broadcast();
  StreamSink<double> get _inTasksProgress => _tasksProgressController.sink;
  Stream<double> get tasksProgress => _tasksProgressController.stream;


  final _tasksEventController = StreamController<Task>();
  StreamSink<Task> get addTaskEvent => _tasksEventController.sink;

  final _loadToDoListEventController = StreamController<int>();
  StreamSink<int> get addToDoListUidEvent => _loadToDoListEventController.sink;

  TaskBloc() {
    _taskServices = TaskServices();
    this._tasksSearchController.stream.listen(_handleSearch);
    this._loadToDoListEventController.stream.listen(_handleAddToDoListUidEvent);
    this._tasksEventController.stream.listen(_handleAddTaskEvent);
  }


  void _handleSearch(String search) async {
    if(search == "") {
      _tasksOfToDoList = await _taskServices.getAllTasksFromTodo(toDoListUid);
    } else {
      _tasksOfToDoList = await _taskServices.getAllTasksFromToDoListBySearch(toDoListUid, search);
    }
    _inTasks.add(_tasksOfToDoList);
  }

  void _handleAddToDoListUidEvent(int uid) {
    this.toDoListUid = uid;
    _updateTasks();
  }

  void _handleAddTaskEvent(Task task) async {
    if (task.uid == null) {
      await _taskServices.insertNewTask(task);
    } else {
      await _taskServices.updateExistingTask(task);
    }
    _updateTasks();
  }

  void _updateTasks() async {
    _tasksOfToDoList = await _taskServices.getAllTasksFromTodo(toDoListUid);
    _inTasks.add(_tasksOfToDoList);
    _updateTasksProgress();
  }

  void _updateTasksProgress() {
    final countCompleted = _tasksOfToDoList.where((item) => item.isFinished).length;
    final countTotal = _tasksOfToDoList.length;
    if(countTotal == 0) {
      _inTasksProgress.add(0);
      return;
    }
    final progress = countCompleted / countTotal;
    _inTasksProgress.add(progress);
  }

  

  @override
  void dispose() {
    _tasksEventController.close();
    _tasksController.close();
    _loadToDoListEventController.close();
    _tasksProgressController.close();
    _tasksSearchController.close();
    super.dispose();
  }
}