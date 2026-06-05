import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/user.dart';

part 'users_state.freezed.dart';
part 'users_state.g.dart';

@freezed
class UsersState with _$UsersState {
  factory UsersState({required List<User> users, required bool isCachedData}) =
      _UsersState;

  factory UsersState.fromJson(Map<String, dynamic> json) =>
      _$UsersStateFromJson(json);
}
