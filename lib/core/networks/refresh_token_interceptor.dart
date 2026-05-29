import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import 'dio_provider.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  final AuthRepository authRepository;

  RefreshTokenInterceptor({required this.dio, required this.authRepository});

  @override
  onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final newTokens = await authRepository.refreshTokens();

      // Retry the original request with the new access token
      final options = err.requestOptions;

      // Safely update the Authorization header with the new access token
      // This will also be done by the AuthInterceptor for subsequent requests,
      // but we need to ensure the current request is retried with the new token
      options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

      final response = await dio.fetch(options);

      return handler.resolve(response);
    } catch (e) {
      // If token refresh fails, pass the original error
      await authRepository.logout();

      return handler.next(err);
    }
  }
}

final refreshTokenInterceptorProvider = Provider<RefreshTokenInterceptor>((
  ref,
) {
  return RefreshTokenInterceptor(
    dio: ref.read(dioProvider),
    authRepository: ref.read(authRepositoryProvider),
  );
});
