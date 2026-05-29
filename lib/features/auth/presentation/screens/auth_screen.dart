import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Auth Screen'),
            authState.when(
              data: (authState) {
                if (authState.isLoggedIn) {
                  return Column(
                    children: [
                      Text('Logged in with tokens: ${authState.authTokens}'),
                      ElevatedButton(
                        onPressed: () {
                          context.push(AppRoutes.userList);
                        },
                        child: Text('Go to Users'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          authNotifier.logout();
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      authNotifier.signInWithEmailAndPassword(
                        email: 'email',
                        password: 'password',
                      );
                    },
                    child: Text('Login'),
                  );
                }
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }
}
