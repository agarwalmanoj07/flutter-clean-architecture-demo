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
      return DataResult(
        data: await remoteDataSource.getUsers(pageNumber: pageNumber),
        isCacheData: false,
      );
    } catch (e) {
      return DataResult(
        data: await localDataSource.getUsers(),
        isCacheData: true,
      );
    }
  }
}
