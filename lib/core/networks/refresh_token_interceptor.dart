import 'package:dio/dio.dart';

import '../../features/auth/data/repositories/auth_repository.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  final AuthRepository authRepository;

  RefreshTokenInterceptor({required this.dio, required this.authRepository});
}
