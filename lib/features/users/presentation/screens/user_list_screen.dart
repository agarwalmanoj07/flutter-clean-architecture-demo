import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/users_provider.dart';
import '../widgets/user_card.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.6) {
      ref.read(usersProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

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
              child: usersState.when(
                loading: () => Center(child: const CircularProgressIndicator()),

                error: (e, s) {
                  return ErrorView(message: e.toString());
                },

                data: (usersState) {
                  final users = usersState.users;
                  final isCachedData = usersState.isCachedData;

                  if (users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }

                  return Column(
                    children: [
                      if (isCachedData)
                        Container(
                          width: double.infinity,
                          color: Colors.amber,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Showing cached data. Pull to refresh.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: usersState.users.length,
                          controller: _scrollController,
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
                        ),
                      ),
                    ],
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
