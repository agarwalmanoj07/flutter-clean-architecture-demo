import 'package:dio/dio.dart';

import 'package:flutter_clean_architecture_demo/core/constants/api_constants.dart';
import 'package:flutter_clean_architecture_demo/core/networks/auth_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(authLocalDataSource: ref.read(authLocalDataSourceProvider)),
  );

  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
});
