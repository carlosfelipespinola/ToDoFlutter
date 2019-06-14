import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/models/ToDoList.dart';
import 'package:to_do_flutter/to-do/pages/ToDoListPage.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:to_do_flutter/to-do/BLoC/ToDoListBLoC.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toDoListBloc = BlocProvider.getBloc<ToDoListBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("To-do lists"),
      ),
      body: _buildBody(context, toDoListBloc),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _buildAndShowBottomSheet(context, toDoListBloc)),
    );
  }

  Widget _buildBody(BuildContext context, ToDoListBloc toDoListBloc) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildToDoListsCounter(context, toDoListBloc),
          Expanded(child: _buildListOfToDoLists(context, toDoListBloc)),
        ],
      ),
    );
  }

  Widget _buildToDoListsCounter(
      BuildContext context, ToDoListBloc toDoListbloc) {
    return StreamBuilder<List<ToDoList>>(
        stream: toDoListbloc.toDoLists,
        initialData: [],
        builder: (context, snapshot) {
          return Text('${snapshot.data.length ?? 0} listas cadastradas');
        });
  }

  Widget _buildListOfToDoLists(
      BuildContext context, ToDoListBloc toDoListBloc) {
    toDoListBloc.addReloadToDoListsEventSink.add(null);
    return StreamBuilder<List<ToDoList>>(
        stream: toDoListBloc.toDoLists,
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final toDoLists = snapshot.data;
          return ListView.builder(
            itemCount: toDoLists.length,
            itemBuilder: (context, index) {
              final currentItem = toDoLists[index];
              return ToDoTile(
                title: currentItem.name,
                progress: (currentItem.percentage / 100),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ToDoListPage(
                            toDoList: currentItem,
                          )));
                },
              );
            },
          );
        });
  }

  _buildAndShowBottomSheet(BuildContext context, ToDoListBloc toDoListBloc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            _buildModalBottomSheet(context, toDoListBloc));
  }

  Widget _buildModalBottomSheet(
      BuildContext context, ToDoListBloc toDoListBloc) {
    final TextEditingController toDoListNameController =
        TextEditingController();
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
              controller: toDoListNameController,
              decoration: InputDecoration(labelText: "ToDo list name"),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              toDoListBloc.addToDoListEventSink
                  .add(ToDoList(name: toDoListNameController.text));
              toDoListNameController.clear();
            },
            child: Text("ADD"),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
