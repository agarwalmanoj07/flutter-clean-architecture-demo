import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_tokens.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  final bool isLoggedIn;
  final AuthTokens? authTokens;

  AuthState({required this.isLoggedIn, this.authTokens});

  AuthState copyWith({bool? isLoggedIn, AuthTokens? authTokens}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      authTokens: authTokens ?? this.authTokens,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get authRepository => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    final isLoggedIn = await authRepository.isLoggedIn();
    final authTokens = await authRepository.getAuthTokens();

    return AuthState(isLoggedIn: isLoggedIn, authTokens: authTokens);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    await authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final isLoggedIn = await authRepository.isLoggedIn();
    final authTokens = await authRepository.getAuthTokens();

    final currentState = state.valueOrNull;

    if (currentState == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(isLoggedIn: isLoggedIn, authTokens: authTokens),
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    await authRepository.logout();

    final isLoggedIn = await authRepository.isLoggedIn();
    final authTokens = await authRepository.getAuthTokens();

    final currentState = state.valueOrNull;

    if (currentState == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(isLoggedIn: isLoggedIn, authTokens: authTokens),
    );
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await authRepository.isLoggedIn();
    final authTokens = await authRepository.getAuthTokens();

    state = AsyncValue.data(
      AuthState(isLoggedIn: isLoggedIn, authTokens: authTokens),
    );
  }

  Future<void> clearTokens() async {
    await authRepository.clearTokens();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
