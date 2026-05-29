import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/shared_preferences_provider.dart';
import '../../../../core/storage/storage_keys.dart';
import '../models/user.dart';

abstract class UserLocalDataSource {
  Future<void> saveUsers(List<User> users);

  Future<List<User>> getUsers();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUsers(List<User> users) async {
    final userJsonList = users.map((user) => user.toJson()).toList();

    final jsonString = jsonEncode(userJsonList);

    sharedPreferences.setString(StorageKeys.users, jsonString);
  }

  @override
  Future<List<User>> getUsers() async {
    final jsonString = sharedPreferences.getString(StorageKeys.users);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> userJsonList = jsonDecode(jsonString);

    final users = userJsonList
        .map<User>((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();

    return users;
  }
}

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSourceImpl(ref.read(sharedPreferencesProvider));
});
