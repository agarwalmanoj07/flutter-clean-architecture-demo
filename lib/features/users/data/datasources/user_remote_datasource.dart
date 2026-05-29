import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/networks/dio_provider.dart';
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
        '/userss?page=$pageNumber&page_size=$pageSize',
      );

      final List users = response.data;

      return users.map((json) => User.fromJson(json)).toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    }
  }
}

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSourceImpl(ref.read(dioProvider)),
);
