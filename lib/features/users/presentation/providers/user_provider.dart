import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/networks/dio_provider.dart';
import '../../../../core/storage/shared_preferences_provider.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/datasources/user_remote_datasource.dart';
import 'users_notifier.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSourceImpl(ref.read(dioProvider)),
);

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSourceImpl(ref.read(sharedPreferencesProvider));
});

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.read(userRemoteDataSourceProvider),
    ref.read(userLocalDataSourceProvider),
  ),
);

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(
  (UsersNotifier.new),
);
