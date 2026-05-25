import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/error_view.dart';
import '../../data/models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SearchBar(
            onChanged: (query) {
              ref.read(usersProvider.notifier).search(query);
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(usersProvider.notifier).refresh();
              },
              child: users.when(
                loading: () => Center(child: const CircularProgressIndicator()),

                error: (e, s) => ErrorView(message: e.toString()),

                data: (users) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      return UserCard(
                        user: users[index],
                        onTap: () {
                          context.push(
                            AppRoutes.userDetails,
                            extra: users[index],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          ref.read(usersProvider.notifier).refresh();
        },
      ),
    );
  }
}
