import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_demo/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture_demo/features/auth/data/models/auth_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  // This is a placeholder for the actual implementation of the AuthInterceptor.
  // In a real application, this would include logic to intercept HTTP requests
  // and add authentication headers or handle token refreshes.

  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({required this.authLocalDataSource});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tokens = await authLocalDataSource.getTokens();

    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }

    print('Authorization: Bearer ${tokens?.accessToken}');

    super.onRequest(options, handler);
  }
}

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    authLocalDataSource: ref.read(authLocalDataSourceProvider),
  );
});
