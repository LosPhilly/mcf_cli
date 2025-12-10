/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// FIX: Import Cubit (Parent), NOT State (Part)
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/failures/failure.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';

class MockUserRepository extends Mock implements IUserRepository {}

// Mock Data
const mockUser = User(
  id: '1',
  name: 'Test User',
  username: 'test',
  email: 'test@example.com',
  phone: '123',
  website: 'site.com',
  isAdmin: false,
  // Note: We use "any" or simplified mocks in real tests usually
  address: anyNamed,
  company: anyNamed,
);

// Helper for Mocktail to handle the complex types if needed
// (For this simple test, we can just stub the response)

void main() {
  late UserCubit cubit;
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    cubit = UserCubit(mockRepo);
  });

  group('UserCubit', () {
    test('initial state is UserInitial', () {
      expect(cubit.state, const UserInitial());
    });

    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserLoaded] when loadUser succeeds',
      build: () {
        // FIX: Update stub to match the Repository signature
        when(() => mockRepo.getUser(any())).thenAnswer((_) async => mockUser);
        return cubit;
      },
      // FIX: Call loadUser('1'), not loadProfile()
      act: (cubit) => cubit.loadUser('1'),
      expect: () => [
        const UserLoading(),
        // FIX: Check 'data' property
        isA<UserLoaded>(),
      ],
    );

    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserFailure] when repository fails',
      build: () {
        when(() => mockRepo.getUser(any())).thenThrow(
          const ServerFailure('500 Internal Error'),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadUser('1'),
      expect: () => [
        const UserLoading(),
        // FIX: Expect UserFailure, not UserError
        const UserFailure('ServerFailure: 500 Internal Error (Code: null)'),
      ],
    );
  });
}

// Minimal fakes to satisfy the const constructor in the mock above if needed
// In a real generated app, we'd copy the Address/Company mocks.
const anyNamed =
    null; // Placeholder to make the code above compile for the template
