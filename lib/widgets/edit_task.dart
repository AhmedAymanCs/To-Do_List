import 'package:flutter/material.dart';
import 'package:todo_list/constant/font_size.dart';
import 'package:todo_list/models/task_model.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskModel task;
  final Function(String newName) onSave;

  const EditTaskDialog({required this.task, required this.onSave, super.key});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task', style: TextStyle(fontSize: FontSize.medium)),
      content: TextField(
        controller: nameController,
        style: TextStyle(fontSize: FontSize.medium),
        decoration: const InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(nameController.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
