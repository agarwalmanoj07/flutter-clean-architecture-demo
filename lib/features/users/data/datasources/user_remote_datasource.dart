import 'package:dio/dio.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../models/user.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<List<User>> getUsers({required int pageNumber, int limit = 7}) async {
    try {
      final response = await dio.get(
        '/users?page=$pageNumber&page_size=$limit',
      );

      final List users = response.data;

      final allUsers = users.map((json) => User.fromJson(json)).toList();

      return allUsers.skip((pageNumber - 1) * limit).take(limit).toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }

  Future<User> getUser(int id) async {
    final response = await dio.get('/users/$id');

    return User.fromJson(response.data['data']);
  }

  Future<User> createUser(User user) async {
    final response = await dio.post('/users', data: user.toJson());

    return User.fromJson(response.data);
  }

  Future<User> updateUser(User user) async {
    final response = await dio.put('/users/${user.id}', data: user.toJson());

    return User.fromJson(response.data);
  }

  Future<void> deleteUser(int id) async {
    await dio.delete('/users/$id');
  }

  Future<void> deleteAllUsers() async {
    await dio.delete('/users');
  }
}
