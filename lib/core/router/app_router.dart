import 'package:go_router/go_router.dart';
import 'package:task/feature/pages/auth_page.dart';

import 'package:task/feature/pages/reg_page.dart';
import 'package:task/feature/pages/task_page.dart';

abstract class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: AuthPage.path, routes: [
    GoRoute(
      path: AuthPage.path,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: RegPage.path,
      builder: (context, state) => const RegPage(),
    ),
    GoRoute(
      path: TaskPage.path,
      builder: (context, state) => const TaskPage(),
    ),
  ]);
}
