import 'package:flutter/material.dart';

class ToDoTaskTile extends StatelessWidget {

  final String title;
  final bool checked;
  final void Function(bool) change;

  ToDoTaskTile({@required this.title, @required this.checked, @required this.change});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: this.checked,
            onChanged: this.change,
            activeColor: Theme.of(context).accentColor,
            checkColor: Theme.of(context).backgroundColor,
          ),
          Flexible(child: Text(this.title, style: Theme.of(context).textTheme.body2, overflow: TextOverflow.ellipsis, ))
        ],
      ),
    );
  }
}
