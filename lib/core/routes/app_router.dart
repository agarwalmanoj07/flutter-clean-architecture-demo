import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/users/data/models/user.dart';
import '../../features/users/presentation/screens/user_details_screen.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.auth,
    redirect: (context, state) {
      final authState = auth.valueOrNull;

      if (authState == null) {
        return AppRoutes.auth;
      }

      final isLoggedIn = authState.isLoggedIn;

      final isAuthRoute = state.matchedLocation == AppRoutes.auth;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.auth;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.userList;
      }

      return null;
    },
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
        builder: (context, state) =>
            UserDetailsScreen(user: state.extra as User),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );
});
