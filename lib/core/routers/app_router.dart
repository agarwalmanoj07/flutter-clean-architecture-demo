import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/users/data/models/user.dart';
import '../../features/users/presentation/screens/user_details_screen.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';
import 'app_routes.dart';
import 'router_refresh_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerRefreshNotifier = ref.read(routerRefreshProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: routerRefreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);

      if (auth.isLoading) {
        return null;
      }

      final authState = auth.valueOrNull;

      if (authState == null) {
        return AppRoutes.login;
      }

      final isLoggedIn = authState.isLoggedIn;

      final isSplashRoute = state.matchedLocation == AppRoutes.splash;

      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn) {
        return isLoginRoute ? null : AppRoutes.login;
      }

      if (isSplashRoute || isLoginRoute) {
        return AppRoutes.userList;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
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
