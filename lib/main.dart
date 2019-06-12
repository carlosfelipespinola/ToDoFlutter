import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/pages/HomePage.dart';
import 'package:to_do_flutter/to-do/pages/ToDoListPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.pink
      ),
      home: ToDoListPage(),
    );
  }
}

