import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/BLoC/events/ToDoListEvent.dart';
import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTaskTile.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/BLoC/TaskBLoC.dart';
import 'package:to_do_flutter/to-do/BLoC/ToDoListBLoC.dart';

import 'SearchTasksInToDoList.dart';

enum CollapsedAppBarActions { edit, delete }

var TO_DOS = [
  {"done": true, "title": "Captain America: The First Avenger"},
  {"done": false, "title": "Captain Marvel"},
  {"done": true, "title": "Spiderman: Far From Home"},
];

class ToDoListPage extends StatefulWidget {
  final ToDoList toDoList;


  ToDoListPage({Key key, @required this.toDoList}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool editMode = false;
  final TextEditingController editTitleController = TextEditingController();
  final toDoListBloc = BlocProvider.getBloc<ToDoListBloc>();
  final taskBloc = BlocProvider.getBloc<TaskBloc>();
  @override
  Widget build(BuildContext context) {
    editTitleController.text = this.widget.toDoList.name;
    taskBloc.addToDoListUidEvent.add(this.widget.toDoList.uid);
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
      title: _buildAppBarTitle(context),
      actions: _buildAppBarActions(context),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    if ( editMode ) {
      return _buildAppBarTitleEditMode(context);
    }
    return _buildAppBarTitleViewMode(context);
  }

  Widget _buildAppBarTitleEditMode(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(bottom: 4.0),
      child: TextField(
        autofocus: true,
        controller: editTitleController,
        decoration: InputDecoration(labelText: "To-do List Name"),
      ),
    );
  }

  Widget _buildAppBarTitleViewMode(BuildContext context) {
    return Text(widget.toDoList.name);
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    if ( editMode ) {
      return _buildAppBarActionsEditMode(context);
    }
    return _buildAppBarActionsViewMode(context);
  }

  List<Widget> _buildAppBarActionsEditMode(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            editMode = false;
          });
        },
        icon: Icon(Icons.close),
      ),
      IconButton(
        onPressed: () {
          widget.toDoList.name = editTitleController.text;
          toDoListBloc.addToDoListEventSink.add(ToDoListEvent(Actions.update, widget.toDoList));
          setState(() {
            editMode = false;
          });
        },
        icon: Icon(Icons.check),
      ),
    ];
  }

  List<Widget> _buildAppBarActionsViewMode(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          await showSearch(context: context, delegate: SearchTasksInToDoList(taskBloc));
          BlocProvider.getBloc<ToDoListBloc>().addReloadToDoListsEventSink.add(null);
        }
      ),
      PopupMenuButton<CollapsedAppBarActions>(
        onSelected: (CollapsedAppBarActions selectedAction) {
          switch (selectedAction) {
            case CollapsedAppBarActions.edit:
              setState(() {
                editMode = true;
              });
              break;
            case CollapsedAppBarActions.delete:
              toDoListBloc.addToDoListEventSink.add(ToDoListEvent(Actions.delete, widget.toDoList));
              Navigator.of(context).pop();
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) {
          return CollapsedAppBarActions.values.map((item) {
            return PopupMenuItem<CollapsedAppBarActions>(
              value: item,
              child: Text(item.toString().split('.')[1]),
            );
          }).toList();
        },
      )
    ];
  }

  Widget _buildProgressbar(BuildContext context) {
    return StreamBuilder<double>(
      stream: taskBloc.tasksProgress,
      initialData: 0,
      builder: (context, snapshot) {
        return LinearProgressIndicator(
          value: snapshot.data,
          backgroundColor: Theme.of(context).backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        );
      }
    );
  }

  Widget _buildTaskList(BuildContext context) {
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
                  toDoUid: widget.toDoList.uid,
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
