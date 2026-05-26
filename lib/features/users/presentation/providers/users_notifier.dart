import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';
import 'user_provider.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  final List<User> _allUsers = [];

  int _currentPage = 1;

  bool _hasMore = true;

  bool _isLoading = false;

  String _searchQuery = '';

  UserRepository get userRepository => ref.read(userRepositoryProvider);

  @override
  Future<List<User>> build() async {
    final users = await userRepository.getUsers(pageNumber: _currentPage);

    _allUsers.clear();
    _allUsers.addAll(users);

    return _allUsers;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    clearPaginationState();

    final users = await userRepository.getUsers(pageNumber: _currentPage);

    _allUsers.clear();
    _allUsers.addAll(users);

    _applySearch();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;

    try {
      final users = await userRepository.getUsers(pageNumber: _currentPage + 1);

      _allUsers.addAll(users);

      _currentPage++;

      _hasMore = users.isNotEmpty;

      _applySearch();

      _isLoading = false;
    } finally {
      _isLoading = false;
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      state = AsyncValue.data(_allUsers);
    } else {
      final filteredUsers = _allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.email.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      state = AsyncValue.data(filteredUsers);
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applySearch();
  }

  void clearPaginationState() {
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
  }

  void clearUsers() {
    _allUsers.clear();
    state = const AsyncValue.data([]);
  }

  void clearState() {
    clearUsers();
    clearPaginationState();
    clearSearch();
  }

  void sortUsers() {
    _allUsers.sort((a, b) => a.name.compareTo(b.name));
    state = AsyncValue.data(_allUsers);
  }
}
