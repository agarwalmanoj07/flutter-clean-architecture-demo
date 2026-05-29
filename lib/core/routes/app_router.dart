import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/users/data/models/user.dart';
import '../../features/users/presentation/screens/user_details_screen.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';

class AppRoutes {
  static const String auth = '/';
  static const String userList = '/users';
  static const String userDetails = '/user-details';
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.userList,
      builder: (context, state) => const UserListScreen(),
    ),
    GoRoute(
      path: AppRoutes.userDetails,
      builder: (context, state) => UserDetailsScreen(user: state.extra as User),
    ),
  ],

  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text(state.error.toString()))),
);
