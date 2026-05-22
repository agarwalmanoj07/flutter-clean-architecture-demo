import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import 'user_provider.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  UserRepository get userRepository => ref.read(userRepositoryProvider);

  @override
  Future<List<User>> build() async {
    return userRepository.getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return userRepository.getUsers();
    });
  }
}
