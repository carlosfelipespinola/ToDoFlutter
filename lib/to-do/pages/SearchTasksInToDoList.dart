import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/BLoC/SearchTaskBLoC.dart';
import 'package:to_do_flutter/to-do/BLoC/TaskBLoC.dart';
import 'package:to_do_flutter/to-do/models/Task.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTaskTile.dart';

class SearchTasksInToDoList extends SearchDelegate<List<Task>> {
  TaskBloc bloc;
  SearchTasksInToDoList(TaskBloc bloc) {
    this.bloc = bloc;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _addQueryAndBuildStreamBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _addQueryAndBuildStreamBuilder();
  }

  Widget _addQueryAndBuildStreamBuilder() {
    bloc.inSearchTask.add(query);
    return StreamBuilder<List<Task>>(
        stream: bloc.tasks,
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildListOfTasks(snapshot.data);
        }
    );
  }

  Widget _buildListOfTasks(List<Task> tasks) {
    return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return ToDoTaskTile(
              title: task.name,
              checked: task.isFinished,
              change: (checked) {
                task.isFinished = checked;
                bloc.addTaskEvent.add(task);
                //BlocProvider.getBloc<ToDoListBloc>().addReloadToDoListsEventSink.add(null);
              });
        });
  }

}