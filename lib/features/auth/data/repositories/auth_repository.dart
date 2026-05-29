import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_tokens.dart';

abstract class AuthRepository {
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<bool> isLoggedIn();

  Future<void> logout();

  Future<AuthTokens?> getAuthTokens();

  Future<void> clearTokens();

  Future<AuthTokens> refreshTokens(String refreshToken);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<AuthTokens> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await localDataSource.saveTokens(tokens);
    } catch (e) {
      throw AppException('Failed to sign in: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.getTokens().then((tokens) => tokens != null);
    } catch (e) {
      AppException('Failed to check login status: $e');
      return Future.value(false);
    }
  }

  @override
  Future<AuthTokens?> getAuthTokens() {
    try {
      return localDataSource.getTokens();
    } catch (e) {
      AppException('Failed to get auth tokens: $e');
      return Future.value(null);
    }
  }

  @override
  Future<void> logout() async {
    try {
      return await localDataSource.clearTokens();
    } catch (e) {
      AppException('Failed to logout: $e');
    }
  }

  @override
  Future<void> clearTokens() {
    // TODO: implement clearTokens
    throw UnimplementedError();
  }

  @override
  Future<AuthTokens> refreshTokens(String refreshToken) async {
    final currentTokens = await localDataSource.getTokens();

    if (currentTokens == null) {
      throw AppException('Session expired');
    }

    final newTokens = await remoteDataSource.refreshToken(
      currentTokens.refreshToken,
    );

    await localDataSource.saveTokens(newTokens);

    return newTokens;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(authLocalDataSourceProvider),
  ),
);
