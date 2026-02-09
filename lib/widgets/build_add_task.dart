import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/constant/font_size.dart';

class BuildAddTask extends StatefulWidget {
  TextEditingController nameController = TextEditingController();
  final VoidCallback addTask;
  final VoidCallback changeDate;
  DateTime? selectedDate;
  BuildAddTask({
    super.key,
    required this.addTask,
    required this.nameController,
    required this.changeDate,
    this.selectedDate,
  });

  @override
  State<BuildAddTask> createState() => _BuildAddTaskState();
}

class _BuildAddTaskState extends State<BuildAddTask> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.nameController,
                  style: TextStyle(fontSize: FontSize.medium),
                  decoration: InputDecoration(
                    hintText: 'Enter task...',
                    hintStyle: TextStyle(fontSize: FontSize.medium),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: widget.addTask,
                child: Text('Add', style: TextStyle(fontSize: FontSize.small)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const SizedBox(width: 2),
              Text(
                widget.selectedDate == null
                    ? 'No due date'
                    : 'Due: ${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}',
                style: TextStyle(fontSize: FontSize.medium, color: Colors.grey),
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed:
                    widget.changeDate, // helper function to pick due date
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.nameController.dispose();
  }
}
