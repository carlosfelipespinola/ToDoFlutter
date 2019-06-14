import 'dart:async';
import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/services/ToDoListServices.dart';


class ToDoListBloc extends BlocBase {
  ToDoListServices _toDoListServices;

  List<ToDoList> _toDoLists = [];
  final _toDoListsController = StreamController<List<ToDoList>>();
  StreamSink<List<ToDoList>> get _inToDoLists => _toDoListsController.sink;
  Stream<List<ToDoList>> get toDoLists => _toDoListsController.stream;

  final _toDoListsEventController = StreamController<ToDoList>();
  StreamSink<ToDoList> get addToDoListEventSink => _toDoListsEventController.sink;
  
  ToDoListBloc() {
    _toDoListsEventController.stream.listen(_handleAddToDoEvent);
    _toDoListServices = new ToDoListServices();
    _toDoListServices.getAllToDoLists().then((value) {
      _toDoLists = value;
      _inToDoLists.add(_toDoLists);
    })
    .catchError((error) {

    });
  }

  void _handleAddToDoEvent(ToDoList toDo) async {
    _toDoListServices.insertNewTodoList(toDo);
    _toDoLists = await _toDoListServices.getAllToDoLists();
    _inToDoLists.add(_toDoLists);
  }

  @override
  void dispose() {
    _toDoListsController.close();
    _toDoListsEventController.close();
    super.dispose();
  }
}