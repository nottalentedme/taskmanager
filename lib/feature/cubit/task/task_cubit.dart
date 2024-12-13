import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/feature/cubit/task/task_cubit_state.dart';
import 'package:task/feature/model/task_model.dart';
import 'package:task/feature/repository/task_repository.dart';

class TaskCubit extends Cubit<TaskCubitState> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super(TaskCubitInitial());

  void loadTasks() {
    emit(TaskCubitLoading());
    _repository.getTasks().listen(
      (tasks) {
        emit(TaskCubitLoaded(tasks));
      },
      onError: (error) {
        emit(TaskCubitError(error.toString()));
      },
    );
  }

  Future<void> addTask(String title, String description) async {
    try {
      await _repository.addTask(title, description);
    } catch (e) {
      emit(TaskCubitError(e.toString()));
    }
  }

  Future<void> changeTaskStatus(TaskModel task) async {
    try {
      await _repository.updateTask(TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          isCompleted: !task.isCompleted));
    } catch (e) {
      emit(TaskCubitError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
    } catch (e) {
      emit(TaskCubitError(e.toString()));
    }
  }
}
