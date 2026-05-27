import 'package:dio/dio.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../models/user.dart';

abstract class UserRemoteDataSource {
  Future<List<User>> getUsers({required int pageNumber, int pageSize = 10});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<List<User>> getUsers({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    try {
      final response = await dio.get(
        '/users?page=$pageNumber&page_size=$pageSize',
      );

      final List users = response.data;

      return users.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}
