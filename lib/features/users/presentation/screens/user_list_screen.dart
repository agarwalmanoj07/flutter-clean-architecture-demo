import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import 'user_details_screen.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: users.when(
        loading: () => const CircularProgressIndicator(),

        error: (e, s) => Text(e.toString()),

        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              return UserCard(
                user: users[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserDetailsScreen(user: users[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
