import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task/feature/cubit/auth/auth_cubit.dart';
import 'package:task/feature/cubit/auth/auth_cubit_state.dart';
import 'package:task/feature/pages/reg_page.dart';
import 'package:task/feature/pages/task_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  static const String path = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthCubitAuthorized) {
          context.go(TaskPage.path);
        } else if (state is AuthCubitUnauthorized && state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            TextButton(onPressed: () {context.go(RegPage.path);}, child: const Text('Register'))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().signIn(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  child: BlocBuilder<AuthCubit, AuthCubitState>(
                    builder: (context, state) {
                      if (state is AuthCubitLoading) {
                        return const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(),
                        );
                      }
                      return const Text('Log in');
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
