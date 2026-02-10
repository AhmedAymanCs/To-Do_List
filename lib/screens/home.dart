import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/screens/helpers.dart';
import 'package:todo_list/screens/logic/cubit.dart';
import 'package:todo_list/screens/logic/states.dart';
import 'package:todo_list/widgets/build_add_task.dart';
import 'package:todo_list/widgets/build_filters.dart';
import 'package:todo_list/widgets/delete_task.dart';
import 'package:todo_list/widgets/edit_task.dart';
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
                addTask: (value) {
                  cubit.taskName = value;
                  cubit.addTask(
                    TaskModel(
                      name: cubit.taskName!.trim(),
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
                        showDialog(
                          context: context,
                          builder: (context) => EditTaskDialog(
                            task: task,
                            onSave: (newName) {
                              cubit.editTask(task, newName);
                            },
                          ),
                        );
                      },
                      task: task,
                      toggleTask: () {
                        cubit.toggleTask(task);
                      },
                      deleteTask: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteConfirmationDialog(
                            onDelete: () {
                              cubit.deleteTask(task);
                            },
                          ),
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
