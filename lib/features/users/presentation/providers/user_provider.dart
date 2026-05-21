import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/networks/dio_provider.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/datasources/user_remote_datasource.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSource(ref.read(dioProvider)),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.read(userRemoteDataSourceProvider)),
);

final usersProvider = FutureProvider<List<User>>((ref) async {
  return ref.read(userRepositoryProvider).getUsers();
});
