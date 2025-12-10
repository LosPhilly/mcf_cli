/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Dynamic Imports for the generated project
import 'package:{{project_name.snakeCase()}}/domain/entities/address.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/company.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/failures/failure.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_state.dart';

// Mocks allow us to control the "Data Layer" behavior perfectly.
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late UserCubit cubit;
  late MockUserRepository mockRepo;

  // FIX: Define reusable empty constants for the required fields.
  // This satisfies strict null safety without cluttering the test.
  const mockGeo = Geo(lat: '0', lng: '0');
  const mockAddress = Address(
    street: 'Test St',
    suite: 'Apt 1',
    city: 'Test City',
    zipcode: '12345',
    geo: mockGeo,
  );
  const mockCompany = Company(
    name: 'Test Corp',
    catchPhrase: 'Testing',
    bs: 'none',
  );

  // Setup runs before EVERY test to ensure isolation.
  setUp(() {
    mockRepo = MockUserRepository();
    cubit = UserCubit(mockRepo);
  });

  group('UserCubit', () {
    // 1. Verify Initial State
    test('initial state is UserInitial', () {
      expect(cubit.state, const UserInitial());
    });

    // 2. Verify Success Path
    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserLoaded] when loadProfile succeeds',
      build: () {
        when(() => mockRepo.getUser()).thenAnswer(
          (_) async => const User(
            id: '1',
            name: 'Test',
            username: 'testuser',
            email: 'test@test.com',
            phone: '123-456-7890',
            website: 'test.com',
            isAdmin: true,
            // FIX: Pass valid objects, not null
            address: mockAddress,
            company: mockCompany,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const UserLoading(),
        // Verify the emitted state is UserLoaded and check a property
        isA<UserLoaded>().having((s) => s.user.name, 'name', 'Test'),
      ],
    );

    // 3. Verify Failure Path (The Critical Safety Check)
    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserError] when repo throws ServerFailure',
      build: () {
        when(() => mockRepo.getUser()).thenThrow(
          const ServerFailure('500 Internal Error'),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const UserLoading(),
        const UserError('Server Failure: 500 Internal Error'),
      ],
    );
  });
}
