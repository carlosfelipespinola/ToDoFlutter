import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {

  final String title;
  final double progress;

  ToDoTile({@required this.title, @required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(this.title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
          SizedBox(height: 4.0,),
          LinearProgressIndicator(
            value: this.progress,
            backgroundColor: Theme.of(context).backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }
}
