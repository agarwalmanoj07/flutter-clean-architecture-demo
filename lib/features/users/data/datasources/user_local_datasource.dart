import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

    final userJsonList = jsonDecode(jsonString);

    return userJsonList.map((json) => User.fromJson(json)).toList();
  }
}
