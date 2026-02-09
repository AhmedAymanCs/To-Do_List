import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/constant/enums.dart';
import 'package:todo_list/constant/font_size.dart';
import 'package:todo_list/screens/helpers.dart';
import 'package:todo_list/widgets/task_card.dart';
import '../models/task_model.dart';
import '../services/task_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? selectedDate;
  List<TaskModel> tasks = []; // All tasks loaded from storage
  TaskFilter selectedFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    await TaskStorage.init(); // Initialize storage
    setState(() {
      tasks = TaskStorage.loadTasks(); // Load tasks from storage
    });
  }

  List<TaskModel> get filteredTasks => getFilteredTasks(
    selectedFilter,
    tasks,
  ); // helper function to filter tasks based on selected filter

  // ------------------------------------ LOGIC ----------------------------------------

  void addTask() {
    final text = _nameController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task name cannot be empty')),
      );
      return;
    } else if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    } //validation Due Date

    setState(() {
      tasks.add(
        TaskModel(name: text, isCompleted: false, dueDate: selectedDate!),
      );
      _nameController.clear();
      selectedDate = null;
    }); // Update UI

    TaskStorage.saveTasks(tasks); // Store Tasks in Shared Preferences
  }

  void editTask(TaskModel task) {
    TextEditingController newNameController = TextEditingController();
    newNameController.text = task.name;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Task', style: TextStyle(fontSize: FontSize.medium)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newNameController,
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
          TextButton(
            onPressed: () {
              if (newNameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task name cannot be empty')),
                );
                return;
              } //validation Due Date
              setState(() {
                task.name = newNameController.text.trim();
              });
              TaskStorage.saveTasks(tasks); //save changes in storage
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void toggleTask(TaskModel task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    }); // Update UI
    TaskStorage.saveTasks(tasks); // save changes in storage
  }

  // ----------------- UI -----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks'), centerTitle: true),
      body: Column(
        children: [
          _buildAddTask(),
          _buildFilters(),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildAddTask() {
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
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
                onPressed: addTask,
                child: Text('Add', style: TextStyle(fontSize: FontSize.small)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const SizedBox(width: 2),
              Text(
                selectedDate == null
                    ? 'No due date'
                    : 'Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: TextStyle(fontSize: FontSize.medium, color: Colors.grey),
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  pickDueDate(context).then((pickedTime) {
                    setState(() {
                      selectedDate = pickedTime;
                    });
                  });
                }, // helper function to pick due date
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(TaskFilter.values.length, (index) {
            final filter = TaskFilter.values[index];
            final bool isSelected = selectedFilter == filter;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ChoiceChip(
                label: Text(filter.name.toUpperCase()),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks here',
          style: TextStyle(fontSize: FontSize.large),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          editTask: (_) => editTask(task),
          task: task,
          toggleTask: (_) => toggleTask(task),
          deleteTask: (_) => deleteTask(
            context: context,
            onDelete: () {
              setState(() {
                tasks.remove(task);
              });
              TaskStorage.saveTasks(tasks);
              Navigator.pop(context);
            },
          ), // helper function to show confirmation dialog before deleting a task
        );
      },
    );
  }

  // Toggle task completion status (completed/pending)
}
