import '../datasources/user_remote_datasource.dart';
import '../models/user.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<List<User>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  Future<User> getUser(int id) async {
    return await remoteDataSource.getUser(id);
  }

  Future<User> createUser(User user) async {
    return await remoteDataSource.createUser(user);
  }

  Future<User> updateUser(User user) async {
    return await remoteDataSource.updateUser(user);
  }

  Future<void> deleteUser(int id) async {
    await remoteDataSource.deleteUser(id);
  }

  Future<void> deleteAllUsers() async {
    await remoteDataSource.deleteAllUsers();
  }
}
