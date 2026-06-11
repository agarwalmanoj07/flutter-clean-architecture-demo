import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    final authTokens = await _authRepository.getAuthTokens();

    return AuthState(isLoggedIn: isLoggedIn, authTokens: authTokens);
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final isLoggedIn = await _authRepository.isLoggedIn();
    final authTokens = await _authRepository.getAuthTokens();

    state = AsyncValue.data(
      AuthState(isLoggedIn: isLoggedIn, authTokens: authTokens),
    );
  }

  Future<void> isLoggedIn() async {
    state = const AsyncValue.loading();

    final isLoggedIn = await _authRepository.isLoggedIn();

    state = AsyncValue.data(
      AuthState(
        isLoggedIn: isLoggedIn,
        authTokens: state.valueOrNull?.authTokens,
      ),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    await _authRepository.logout();

    final isLoggedIn = await _authRepository.isLoggedIn();
    final authTokens = await _authRepository.getAuthTokens();

    final currentState = state.valueOrNull;

    if (currentState == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(isLoggedIn: isLoggedIn, authTokens: authTokens),
    );
  }

  Future<void> clearTokens() async {
    await _authRepository.clearTokens();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
