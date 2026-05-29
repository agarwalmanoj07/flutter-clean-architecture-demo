import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/storage/secure_storage_provider.dart';
import '../../../../core/storage/storage_keys.dart';
import '../models/auth_tokens.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokens tokens);
  Future<AuthTokens?> getTokens();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    try {
      await secureStorage.write(
        key: StorageKeys.accessToken,
        value: tokens.accessToken,
      );
      await secureStorage.write(
        key: StorageKeys.refreshToken,
        value: tokens.refreshToken,
      );
    } catch (e) {
      AppException('Failed to save tokens: $e');
    }
  }

  @override
  Future<AuthTokens?> getTokens() async {
    try {
      final accessToken = await secureStorage.read(
        key: StorageKeys.accessToken,
      );
      final refreshToken = await secureStorage.read(
        key: StorageKeys.refreshToken,
      );

      if (accessToken != null && refreshToken != null) {
        return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
      }
      return null;
    } catch (e) {
      AppException('Failed to retrieve tokens: $e');
      return null;
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.delete(key: StorageKeys.accessToken);
      await secureStorage.delete(key: StorageKeys.refreshToken);
    } catch (e) {
      AppException('Failed to clear tokens: $e');
    }
  }
}

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) =>
      AuthLocalDataSourceImpl(secureStorage: ref.read(secureStorageProvider)),
);
