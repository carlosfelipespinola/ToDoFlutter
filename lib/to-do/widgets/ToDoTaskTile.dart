import 'package:flutter/material.dart';

class ToDoTaskTile extends StatelessWidget {

  final String title;
  final bool checked;
  final void Function(bool) change;
  final void Function() onEditClick;

  ToDoTaskTile({@required this.title, @required this.checked, @required this.change, this.onEditClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      child: Row(
        children: _buildRowChildren(context)
      ),
    );
  }

  List<Widget> _buildRowChildren(BuildContext context) {
    List<Widget> widgets = [
      Checkbox(
        value: this.checked,
        onChanged: this.change,
        activeColor: Theme.of(context).accentColor,
        checkColor: Theme.of(context).backgroundColor,
      ),
      Expanded(child: Text(this.title, style: Theme.of(context).textTheme.body2, overflow: TextOverflow.ellipsis, )),
    ];

    if(onEditClick != null) {
      widgets.add(IconButton(icon: Icon(Icons.edit), onPressed: onEditClick));
    }
    return widgets;
  }

}
