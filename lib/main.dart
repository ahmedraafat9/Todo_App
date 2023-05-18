import 'package:flutter/material.dart';
import 'package:todo/screens/TodoList.dart';

void main()
{
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData.dark(),
      home: TodoList(),
    );
  }
}
