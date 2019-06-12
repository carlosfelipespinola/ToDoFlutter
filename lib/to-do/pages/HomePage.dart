import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-do lists"),),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('2 listas cadastradas'),
            ToDoTile(
              title: "Filmes da Marvel",
              progress: 1.0,
            ),
            ToDoTile(
              title: "Filmes da DC",
              progress: 0.3,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "ToDo list name"),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text("ADD"),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}
