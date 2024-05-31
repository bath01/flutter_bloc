import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../blocs/todo_bloc.dart';
import '../blocs/todo_event.dart';
import '../blocs/todo_state.dart';
import '../models/todo_model.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: BlocProvider(
        create: (context) =>
            TodoBloc(Hive.box<Todo>('todos'))..add(LoadTodos()),
        child: TodoList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final _todoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: _todoController,
            decoration: InputDecoration(labelText: 'Todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                BlocProvider.of<TodoBloc>(context)
                    .add(AddTodo(_todoController.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TodoLoaded) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (bool? value) {
                    todo.isCompleted = value!;
                    BlocProvider.of<TodoBloc>(context).add(UpdateTodo(todo));
                  },
                ),
                onLongPress: () {
                  BlocProvider.of<TodoBloc>(context).add(DeleteTodo(todo));
                },
              );
            },
          );
        } else {
          return Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
