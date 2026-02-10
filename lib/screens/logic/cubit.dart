import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/constant/enums.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/screens/logic/states.dart';
import 'package:todo_list/services/app_datebase.dart';
import 'package:todo_list/services/task_storage.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  List<TaskModel> tasks = [];
  TaskFilter selectedFilter = TaskFilter.all;
  bool isDarkTheme = false;

  set selectedDateChanged(DateTime? date) {
    selectedDate = date;
    emit(SelectedDateChangedState());
  }

  void initalTheme() async {
    bool isDarkTheme = await AppStorage.getTheme() ?? false;
  }

  void changeTheme() {
    isDarkTheme = !isDarkTheme;
    AppStorage.setTheme(isDarkTheme);
    emit(ThemeChangedState());
  }

  Future<void> getTasks() async {
    emit(TaskLoadingState());
    try {
      final db = await LocalDB.datebase;

      final List<Map<String, dynamic>> result = await db.query('tasks');

      tasks = result.map((task) => TaskModel.fromMap(task)).toList();

      emit(GetTaskSuccessState());
    } catch (error) {
      emit(GetTaskErrorState(error.toString()));
    }
  }

  List<TaskModel> get filteredTasks {
    if (selectedFilter == TaskFilter.completed) {
      return tasks.where((task) => task.isCompleted == 1).toList();
    } else if (selectedFilter == TaskFilter.pending) {
      return tasks.where((task) => task.isCompleted == 0).toList();
    }
    return tasks;
  }

  Future<void> addTask(TaskModel task) async {
    emit(TaskLoadingState());
    final db = await LocalDB.datebase;
    db
        .insert('tasks', task.toMap())
        .then((_) {
          tasks.add(task);
          emit(AddTaskSuccessState());
          nameController.clear();
          selectedDate = null;
        })
        .catchError((error) {
          emit(AddTaskErrorState(error.toString()));
        });
  }

  void toggleTask(TaskModel task) async {
    final db = await LocalDB.datebase;
    final updatedTask = TaskModel(
      id: task.id,
      name: task.name,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted == 1 ? 0 : 1,
    );
    db
        .update(
          'tasks',
          updatedTask.toMap(),
          where: 'id = ?',
          whereArgs: [task.id],
        )
        .then((_) {
          final index = tasks.indexWhere((t) => t.id == task.id);
          if (index != -1) {
            tasks[index] = updatedTask;
            emit(GetTaskSuccessState());
          }
        })
        .catchError((error) {
          emit(GetTaskErrorState(error.toString()));
        });
  }

  Future<void> deleteTask(TaskModel task) async {
    final db = await LocalDB.datebase;
    db
        .delete('tasks', where: 'id = ?', whereArgs: [task.id])
        .then((_) {
          getTasks();
          emit(GetTaskSuccessState());
        })
        .catchError((error) {
          emit(GetTaskErrorState(error.toString()));
        });
  }

  Future<void> editTask(TaskModel task, String newName) async {
    final db = await LocalDB.datebase;
    final updatedTask = TaskModel(
      id: task.id,
      name: newName,
      dueDate: selectedDate ?? task.dueDate,
      isCompleted: task.isCompleted,
    );
    db
        .update(
          'tasks',
          updatedTask.toMap(),
          where: 'id = ?',
          whereArgs: [task.id],
        )
        .then((_) {
          final index = tasks.indexWhere((t) => t.id == task.id);
          if (index != -1) {
            tasks[index] = updatedTask;
            emit(GetTaskSuccessState());
          }
        })
        .catchError((error) {
          emit(GetTaskErrorState(error.toString()));
        });
  }

  void changeFilter(TaskFilter filter) {
    selectedFilter = filter;
    emit(FilterChangedState());
  }
}
