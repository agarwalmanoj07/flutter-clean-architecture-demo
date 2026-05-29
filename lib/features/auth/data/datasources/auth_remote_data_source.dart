import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../models/auth_tokens.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthTokens> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthTokens> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    try {
      // Simulate network delay
      return Future.delayed(const Duration(seconds: 2), () {
        // Simulate successful sign-in with dummy tokens
        return AuthTokens(
          accessToken: 'dummy_access_token',
          refreshToken: 'dummy_refresh_token',
        );
      });
    } catch (e) {
      throw AppException('Failed to sign in: $e');
    }
  }

  @override
  Future<AuthTokens> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(),
);
