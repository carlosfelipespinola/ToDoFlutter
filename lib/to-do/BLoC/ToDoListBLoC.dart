import 'dart:async';
import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/services/ToDoListServices.dart';

import 'events/ToDoListEvent.dart';


class ToDoListBloc extends BlocBase {
  ToDoListServices _toDoListServices;

  List<ToDoList> _toDoLists = [];
  final _toDoListsController = StreamController<List<ToDoList>>.broadcast();
  StreamSink<List<ToDoList>> get _inToDoLists => _toDoListsController.sink;
  Stream<List<ToDoList>> get toDoLists => _toDoListsController.stream;

  final _toDoListsEventController = StreamController<ToDoListEvent>();
  StreamSink<ToDoListEvent> get addToDoListEventSink => _toDoListsEventController.sink;

  final _reloadToDoListsEventController = StreamController();
  StreamSink get addReloadToDoListsEventSink => _reloadToDoListsEventController.sink;
  
  ToDoListBloc() {
    _toDoListServices = new ToDoListServices();
    _toDoListsEventController.stream.listen(_handleAddToDoEvent);
    _reloadToDoListsEventController.stream.listen(_handleAddReloadToDoListsEvent);
    _toDoListServices.getAllToDoLists().then((value) {
      _toDoLists = value;
      _inToDoLists.add(_toDoLists);
    })
    .catchError((error) => {});
  }

  void _handleAddToDoEvent(ToDoListEvent event) async {
    switch(event.action) {
      case Actions.delete:
        await _toDoListServices.deleteToDoList(event.toDoList);
        break;
      case Actions.insert:
        await _toDoListServices.insertNewTodoList(event.toDoList);
        break;
      case Actions.update:
        await _toDoListServices.updateToDoList(event.toDoList);
        break;
      default:
        break;
    }
    _toDoLists = await _toDoListServices.getAllToDoLists();
    _inToDoLists.add(_toDoLists);
  }

  void _handleAddReloadToDoListsEvent(dynamic params) async {
    _toDoLists = await _toDoListServices.getAllToDoLists();
    _inToDoLists.add(_toDoLists);
  }

  @override
  void dispose() {
    _toDoListsController.close();
    _toDoListsEventController.close();
    _reloadToDoListsEventController.close();
    super.dispose();
  }
}