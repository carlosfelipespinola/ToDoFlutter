import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/widgets/ToDoTaskTile.dart';

enum CollapsedAppBarActions { edit, delete }

var TO_DOS = [
  {"done": true, "title": "Captain America: The First Avenger"},
  {"done": false, "title": "Captain Marvel"},
  {"done": true, "title": "Spiderman: Far From Home"},
];

class ToDoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListName"),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Theme.of(context).backgroundColor,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: TO_DOS.length,
              itemBuilder: (context, index) {
                var todo = TO_DOS[index];
                return ToDoTaskTile(
                  title: todo["title"],
                  checked: todo["done"],
                  change: (checked) {}
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
