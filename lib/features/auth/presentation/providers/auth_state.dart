import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/auth_tokens.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  factory AuthState({required bool isLoggedIn, AuthTokens? authTokens}) =
      _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
