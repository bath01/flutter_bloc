import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final Box<Todo> todoBox;

  TodoBloc(this.todoBox) : super(TodoLoading()) {
    on<LoadTodos>((event, emit) {
      final todos = todoBox.values.toList();
      emit(TodoLoaded(todos));
    });

    on<AddTodo>((event, emit) {
      final todo = Todo(
        title: event.title,
        isCompleted: false,
      );
      todoBox.add(todo);
      add(LoadTodos());
    });

    on<UpdateTodo>((event, emit) {
      event.todo.save();
      add(LoadTodos());
    });

    on<DeleteTodo>((event, emit) {
      event.todo.delete();
      add(LoadTodos());
    });
  }
}
