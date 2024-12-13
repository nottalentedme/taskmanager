import 'package:task/feature/model/task_model.dart';

abstract class TaskCubitState {}

class TaskCubitInitial extends TaskCubitState {}

class TaskCubitLoading extends TaskCubitState {}

class TaskCubitLoaded extends TaskCubitState {
  final List<TaskModel> tasks;

  TaskCubitLoaded(this.tasks);
}

class TaskCubitError extends TaskCubitState {
  final String error;

  TaskCubitError(this.error);
}