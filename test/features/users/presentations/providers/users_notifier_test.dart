import 'package:flutter_clean_architecture_demo/core/results/data_result.dart';
import 'package:flutter_clean_architecture_demo/features/users/data/models/user.dart';
import 'package:flutter_clean_architecture_demo/features/users/data/repositories/user_repository.dart';
import 'package:flutter_clean_architecture_demo/features/users/presentation/providers/users_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late ProviderContainer container;

  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();

    container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(mockUserRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('loadUsers', () {
    test('should load users on build', () async {
      // Arrange
      final users = [
        User(id: 1, name: 'John', email: 'john@test.com', username: 'john'),
      ];

      when(
        () => mockUserRepository.getUsers(pageNumber: 1),
      ).thenAnswer((_) async => DataResult(data: users, isCacheData: false));

      // Act
      final result = await container.read(usersProvider.future);

      // Assert
      expect(result.users, users);

      expect(result.isCachedData, false);
    });

    test('should filter users by name', () async {
      // Arrange
      final users = [
        User(id: 1, name: 'John', email: 'john@test.com', username: 'john'),
        User(id: 2, name: 'Alice', email: 'alice@test.com', username: 'alice'),
      ];

      when(
        () => mockUserRepository.getUsers(pageNumber: 1),
      ).thenAnswer((_) async => DataResult(data: users, isCacheData: false));

      // Build notifier

      await container.read(usersProvider.future);

      // Act
      final notifier = container.read(usersProvider.notifier);

      notifier.search('john');

      // Assert
      final state = container.read(usersProvider);

      expect(state.value?.users.length, 1);

      expect(state.value?.users.first.name, 'John');
    });

    test('should refresh users', () async {
      // Arrange

      var callCounter = 0;

      final oldUsers = [
        User(id: 1, name: 'Old User', email: 'old@test.com', username: 'old'),
      ];

      final newUsers = [
        User(id: 2, name: 'New User', email: 'new@test.com', username: 'new'),
      ];

      when(() => mockUserRepository.getUsers(pageNumber: 1)).thenAnswer((
        _,
      ) async {
        callCounter++;

        if (callCounter == 1) {
          return DataResult(data: oldUsers, isCacheData: true);
        }

        return DataResult(data: newUsers, isCacheData: false);
      });

      // Build

      await container.read(usersProvider.future);

      // Act

      final notifier = container.read(usersProvider.notifier);

      await notifier.refresh();

      // Assert

      final state = container.read(usersProvider);

      expect(state.value?.users, newUsers);

      verify(() => mockUserRepository.getUsers(pageNumber: 1)).called(2);
    });
  });
}
