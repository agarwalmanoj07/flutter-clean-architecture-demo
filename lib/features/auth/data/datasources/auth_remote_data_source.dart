import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../models/auth_tokens.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthTokens> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthTokens> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthTokens> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }

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
  Future<AuthTokens> refreshToken(String refreshToken) {
    try {
      // Simulate network delay
      return Future.delayed(const Duration(seconds: 2), () {
        // Simulate successful token refresh with new dummy tokens
        return AuthTokens(
          accessToken: 'new_dummy_access_token',
          refreshToken: 'new_dummy_refresh_token',
        );
      });
    } catch (e) {
      throw AppException('Failed to refresh token: $e');
    }
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(),
);
