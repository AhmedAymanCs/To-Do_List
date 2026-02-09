abstract class AppState {}

class AppInitialState extends AppState {}

class AddTaskLoadingState extends AppState {}

class AddTaskSuccessState extends AppState {}

class AddTaskErrorState extends AppState {
  final String error;
  AddTaskErrorState(this.error);
}
