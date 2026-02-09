import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/screens/logic/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  AppCubit get(context) => BlocProvider.of(context);

  void addTask(TaskModel task) {
    emit(AddTaskLoadingState());
  }
}
