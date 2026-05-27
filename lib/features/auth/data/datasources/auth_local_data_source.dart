import '../models/auth_tokens.dart';

abstract class AuthLocalDataSource {
  Future<AuthTokens?> getTokens();
  Future<void> saveTokens(AuthTokens tokens);
  Future<void> clearTokens();
}
