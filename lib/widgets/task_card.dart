import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) toggleTask;
  final Function(TaskModel) deleteTask;
  final Function(TaskModel) editTask;

  const TaskCard({
    super.key,
    required this.task,
    required this.toggleTask,
    required this.deleteTask,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => editTask(task), // Edit task on tap
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => toggleTask(task),
          ),
          title: Text(
            task.name,
            style: TextStyle(
              fontSize: 14.sp,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: Text(
            'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteTask(task),
          ),
        ),
      ),
    );
  }
}
