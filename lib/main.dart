import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/todo_bloc.dart';
import 'blocs/todo_event.dart';
import 'models/todo_model.dart';
import 'screens/todo_screem.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoBloc(Hive.box<Todo>('todos'))..add(LoadTodos()),
        child: TodoListScreen(),
      ),
    );
  }
}

