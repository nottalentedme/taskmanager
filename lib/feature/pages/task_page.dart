import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task/feature/cubit/auth/auth_cubit.dart';
import 'package:task/feature/cubit/auth/auth_cubit_state.dart';
import 'package:task/feature/cubit/task/task_cubit.dart';
import 'package:task/feature/cubit/task/task_cubit_state.dart';
import 'package:task/feature/pages/auth_page.dart';
import '../model/task_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  static const String path = '/task';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitUnauthorized) {
          context.go(AuthPage.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои задачи'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ],
        ),
        body: BlocBuilder<TaskCubit, TaskCubitState>(
          builder: (context, state) {
            if (state is TaskCubitLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskCubitLoaded) {
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  return _TaskCard(task: state.tasks[index]);
                },
              );
            } else if (state is TaskCubitError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Задач ещё нет'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTaskWidget(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _addTaskWidget(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая задача'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Название задачи',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание задачи',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<TaskCubit>().addTask(
                      titleController.text,
                      descriptionController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            context.read<TaskCubit>().changeTaskStatus(task);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            context.read<TaskCubit>().deleteTask(task.id);
          },
        ),
      ),
    );
  }
}
