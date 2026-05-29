import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';
import 'refresh_token_interceptor.dart';

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

  dio.interceptors.add(
    RefreshTokenInterceptor(
      dio: dio,
      authRepository: ref.read(authRepositoryProvider),
    ),
  );

  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
});
