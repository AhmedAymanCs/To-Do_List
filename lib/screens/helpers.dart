import 'package:flutter/material.dart';
import 'package:todo_list/constant/enums.dart';
import 'package:todo_list/constant/font_size.dart';
import 'package:todo_list/models/task_model.dart';

List<TaskModel> getFilteredTasks(
  TaskFilter selectedFilter,
  List<TaskModel> tasks,
) {
  switch (selectedFilter) {
    case TaskFilter.completed:
      return tasks
          .where((task) => task.isCompleted == 1 ? true : false)
          .toList();
    case TaskFilter.pending:
      return tasks
          .where((task) => task.isCompleted == 1 ? true : false)
          .toList();
    default:
      return tasks;
  }
}

void deleteTask({required BuildContext context, required Function() onDelete}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: onDelete, child: const Text('Delete')),
      ],
    ),
  );
} // Show confirmation dialog before deleting a task

Future<DateTime?> pickDueDate(BuildContext context) async {
  final now = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: DateTime(2050),
  );

  return picked;
} //pick Due Date

void editTask({
  required TaskModel task,
  required BuildContext context,
  required TextEditingController nameController,
  required Function() onSave,
}) {
  nameController.text = task.name;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Edit Task', style: TextStyle(fontSize: FontSize.medium)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(fontSize: FontSize.medium),
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: onSave, child: const Text('Save')),
      ],
    ),
  );
}
