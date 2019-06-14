import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTaskTile.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/BLoC/TaskBLoC.dart';
import 'package:to_do_flutter/to-do/BLoC/ToDoListBLoC.dart';

enum CollapsedAppBarActions { edit, delete }

var TO_DOS = [
  {"done": true, "title": "Captain America: The First Avenger"},
  {"done": false, "title": "Captain Marvel"},
  {"done": true, "title": "Spiderman: Far From Home"},
];

class ToDoListPage extends StatelessWidget {
  final ToDoList toDoList;

  ToDoListPage({Key key, @required this.toDoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.getBloc<TaskBloc>().addToDoListUidEvent.add(this.toDoList.uid);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildProgressbar(context),
          Expanded(child: _buildTaskList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _buildAndShowBottomSheet(context)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(toDoList.name),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        PopupMenuButton<CollapsedAppBarActions>(
          onSelected: (CollapsedAppBarActions selectedAction) {},
          itemBuilder: (context) {
            return CollapsedAppBarActions.values.map((item) {
              return PopupMenuItem<CollapsedAppBarActions>(
                value: item,
                child: Text(item.toString().split('.')[1]),
              );
            }).toList();
          },
        )
      ],
    );
  }

  Widget _buildProgressbar(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.5,
      backgroundColor: Theme.of(context).backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final taskBloc = BlocProvider.getBloc<TaskBloc>();
    return StreamBuilder<List<Task>>(
        stream: taskBloc.tasks,
        initialData: [],
        builder: (context, snapshot) {
          return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var task = snapshot.data[index];
                return ToDoTaskTile(
                    title: task.name,
                    checked: task.isFinished,
                    change: (checked) {
                      task.isFinished = checked;
                      taskBloc.addTaskEvent.add(task);
                      BlocProvider.getBloc<ToDoListBloc>().addReloadToDoListsEventSink.add(null);
                    });
              });
        });
  }

  _buildAndShowBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => _buildModalBottomSheet(context));
  }

  Widget _buildModalBottomSheet(BuildContext context) {
    final TextEditingController taskNameController = TextEditingController();
    final taskBloc = BlocProvider.getBloc<TaskBloc>();
    return Container(
      padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              controller: taskNameController,
              decoration: InputDecoration(labelText: "Task"),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              taskBloc.addTaskEvent.add(Task(
                  toDoUid: toDoList.uid,
                  name: taskNameController.text,
                  isFinished: false));
              taskNameController.clear();
            },
            child: Text("ADD"),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
