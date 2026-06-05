import 'package:flutter_clean_architecture_demo/features/users/data/datasources/user_local_datasource.dart';
import 'package:flutter_clean_architecture_demo/features/users/data/datasources/user_remote_datasource.dart';
import 'package:flutter_clean_architecture_demo/features/users/data/models/user.dart';
import 'package:flutter_clean_architecture_demo/features/users/data/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late UserRepositoryImpl repository;

  late MockUserRemoteDataSource remoteDataSource;

  late MockUserLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = MockUserRemoteDataSource();

    localDataSource = MockUserLocalDataSource();

    repository = UserRepositoryImpl(remoteDataSource, localDataSource);
  });

  group('getUsers', () {
    test('should return remote users and save cache', () async {
      // Arrange
      final users = [
        User(id: 1, name: 'John', email: 'john@test.com', username: 'john'),
      ];

      when(
        () => remoteDataSource.getUsers(pageNumber: 1),
      ).thenAnswer((_) async => users);

      when(() => localDataSource.saveUsers(users)).thenAnswer((_) async {});

      // Act
      final result = await repository.getUsers(pageNumber: 1);

      // Assert
      expect(result.data, users);

      expect(result.isCacheData, false);

      verify(() => localDataSource.saveUsers(users)).called(1);
    });
    test('should return cached users when api fails', () async {
      // Arrange
      final cachedUsers = [
        User(
          id: 1,
          name: 'Cached User',
          email: 'cached@test.com',
          username: 'cached',
        ),
      ];

      when(
        () => remoteDataSource.getUsers(pageNumber: 1),
      ).thenThrow(Exception());

      when(
        () => localDataSource.getUsers(),
      ).thenAnswer((_) async => cachedUsers);

      // Act
      final result = await repository.getUsers(pageNumber: 1);

      // Assert
      expect(result.data, cachedUsers);

      expect(result.isCacheData, true);

      verify(() => localDataSource.getUsers()).called(1);
    });
  });
}
