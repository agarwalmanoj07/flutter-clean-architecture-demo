import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import 'user_provider.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  final List<User> _allUsers = [];

  UserRepository get userRepository => ref.read(userRepositoryProvider);

  @override
  Future<List<User>> build() async {
    final users = await userRepository.getUsers();

    _allUsers.clear();
    _allUsers.addAll(users);

    return _allUsers;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final users = await userRepository.getUsers();

      _allUsers.clear();
      _allUsers.addAll(users);

      return _allUsers;
    });
  }

  void search(String query) {
    final filteredUsers = _allUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    state = AsyncValue.data(filteredUsers);
  }
}
