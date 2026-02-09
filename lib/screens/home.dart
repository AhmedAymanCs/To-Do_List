import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/screens/helpers.dart';
import 'package:todo_list/screens/logic/cubit.dart';
import 'package:todo_list/screens/logic/states.dart';
import 'package:todo_list/widgets/build_add_task.dart';
import 'package:todo_list/widgets/build_filters.dart';
import 'package:todo_list/widgets/task_card.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Tasks'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  cubit.changeTheme();
                },
                icon: const Icon(Icons.brightness_4),
              ),
            ],
          ),
          body: Column(
            children: [
              BuildAddTask(
                changeDate: () {
                  pickDueDate(context).then((pickedTime) {
                    cubit.selectedDateChanged = pickedTime;
                  });
                },
                nameController: cubit.nameController,
                addTask: () {
                  if (cubit.nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task name cannot be empty'),
                      ),
                    );
                    return;
                  }
                  if (cubit.selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please pick a due date')),
                    );
                    return;
                  }
                  cubit.addTask(
                    TaskModel(
                      name: cubit.nameController.text.trim(),
                      dueDate: cubit.selectedDate!,
                    ),
                  );
                },
                selectedDate: cubit.selectedDate,
              ),
              BuildFilters(
                selectedFilter: cubit.selectedFilter,
                onSelected: (filter) {
                  cubit.changeFilter(filter);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cubit.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = cubit.filteredTasks[index];
                    return TaskCard(
                      editTask: () {
                        editTask(
                          task: task,
                          context: context,
                          nameController: cubit.updatedNameController,
                          onSave: () {
                            cubit.editTask(task).then((_) {
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                      task: task,
                      toggleTask: () {
                        cubit.toggleTask(task);
                      },
                      deleteTask: () {
                        deleteTask(
                          context: context,
                          onDelete: () => cubit.deleteTask(task).then((_) {
                            Navigator.pop(context);
                          }),
                        );
                      }, // helper function to show confirmation dialog before deleting a task
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
