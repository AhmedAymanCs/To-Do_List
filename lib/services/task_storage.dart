import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/task_model.dart';

class TaskStorage {
  static late SharedPreferences _prefs;
  static const String _tasksKey = 'tasks';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<TaskModel> loadTasks() {
    final List<String> data = _prefs.getStringList(_tasksKey) ?? [];
    return data.map((task) => TaskModel.fromMap(jsonDecode(task))).toList();
  }

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final List<String> data = tasks
        .map((task) => jsonEncode(task.toMap()))
        .toList();

    await _prefs.setStringList(_tasksKey, data);
  }
}
