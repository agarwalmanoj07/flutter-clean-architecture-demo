import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/results/data_result.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<DataResult<List<User>>> getUsers({required int pageNumber});
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DataResult<List<User>>> getUsers({required int pageNumber}) async {
    try {
      final dataResult = await remoteDataSource.getUsers(
        pageNumber: pageNumber,
      );

      await localDataSource.saveUsers(dataResult);

      return DataResult(data: dataResult, isCacheData: false);
    } catch (e) {
      final cachedUsers = await localDataSource.getUsers();
      return DataResult(data: cachedUsers, isCacheData: true);
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.read(userRemoteDataSourceProvider),
    ref.read(userLocalDataSourceProvider),
  ),
);
