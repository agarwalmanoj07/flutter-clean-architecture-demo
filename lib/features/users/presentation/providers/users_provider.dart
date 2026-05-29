import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class UsersState {
  final List<User> users;
  final bool isCachedData;

  UsersState({required this.users, required this.isCachedData});

  UsersState copyWith({List<User>? users, bool? isCachedData}) {
    return UsersState(
      users: users ?? this.users,
      isCachedData: isCachedData ?? this.isCachedData,
    );
  }
}

class UsersNotifier extends AsyncNotifier<UsersState> {
  final List<User> _allUsers = [];

  int _currentPage = 1;

  bool _hasMore = true;

  bool _isLoading = false;

  String _searchQuery = '';

  UserRepository get userRepository => ref.read(userRepositoryProvider);

  @override
  Future<UsersState> build() async {
    final dataResult = await userRepository.getUsers(pageNumber: _currentPage);

    _allUsers.clear();

    _allUsers.addAll(dataResult.data ?? []);

    return UsersState(users: _allUsers, isCachedData: dataResult.isCacheData);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    clearPaginationState();

    final dataResult = await userRepository.getUsers(pageNumber: _currentPage);

    _allUsers.clear();

    _allUsers.addAll(dataResult.data ?? []);

    final currentState = state.valueOrNull;

    if (currentState != null) {
      state = AsyncValue.data(
        currentState.copyWith(
          users: _allUsers,
          isCachedData: dataResult.isCacheData,
        ),
      );
    } else {
      state = AsyncValue.data(
        UsersState(users: _allUsers, isCachedData: dataResult.isCacheData),
      );
    }

    _applySearch();
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true;

    try {
      final dataResult = await userRepository.getUsers(
        pageNumber: _currentPage + 1,
      );

      _allUsers.addAll(dataResult.data ?? []);

      state = AsyncValue.data(
        state.valueOrNull?.copyWith(users: _allUsers) ??
            UsersState(users: _allUsers, isCachedData: dataResult.isCacheData),
      );

      _currentPage++;

      _hasMore = dataResult.data?.isNotEmpty ?? false;

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
    final currentState = state.valueOrNull;

    if (currentState == null) {
      return;
    }

    if (_searchQuery.isEmpty) {
      state = AsyncValue.data(currentState.copyWith(users: _allUsers));
    } else {
      final filteredUsers = _allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.email.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

      state = AsyncValue.data(currentState.copyWith(users: filteredUsers));
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
    state = AsyncValue.data(UsersState(users: [], isCachedData: false));
  }

  void clearState() {
    clearUsers();
    clearPaginationState();
    clearSearch();
  }

  void sortUsers() {
    _allUsers.sort((a, b) => a.name.compareTo(b.name));
    state = AsyncValue.data(
      state.valueOrNull?.copyWith(users: _allUsers) ??
          UsersState(users: _allUsers, isCachedData: false),
    );
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, UsersState>(
  (UsersNotifier.new),
);
