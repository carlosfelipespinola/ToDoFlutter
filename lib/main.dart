import 'package:flutter/material.dart';
import 'package:to_do_flutter/to-do/BLoC/TaskBLoC.dart';
import 'package:to_do_flutter/to-do/BLoC/ToDoListBLoC.dart';
import 'package:to_do_flutter/to-do/pages/HomePage.dart';
import 'package:to_do_flutter/to-do/pages/ToDoListPage.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => ToDoListBloc()), Bloc((i) => TaskBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.deepPurple,
            accentColor: Colors.pink),
        home: HomePage(),
      ),
    );
  }
}
