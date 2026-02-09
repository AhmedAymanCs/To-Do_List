abstract class AppState {}

class AppInitialState extends AppState {}

class TaskLoadingState extends AppState {}

class GetTaskSuccessState extends AppState {}

class GetTaskErrorState extends AppState {
  final String error;
  GetTaskErrorState(this.error);
}

class SelectedDateChangedState extends AppState {}

class FilterChangedState extends AppState {}

class ThemeChangedState extends AppState {}

class AddTaskSuccessState extends AppState {}

class AddTaskErrorState extends AppState {
  final String error;
  AddTaskErrorState(this.error);
}
