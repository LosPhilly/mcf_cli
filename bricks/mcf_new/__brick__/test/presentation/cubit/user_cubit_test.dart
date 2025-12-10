/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{project_name.snakeCase()}}/domain/entities/address.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/company.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/failures/failure.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';

class MockUserRepository extends Mock implements IUserRepository {}

const mockAddress = Address(
  street: '123 Main St',
  suite: 'Apt 1',
  city: 'Test City',
  zipcode: '12345',
  geo: Geo(lat: '0', lng: '0'),
);

const mockCompany = Company(
  name: 'Test Corp',
  catchPhrase: 'We test things',
  bs: 'testing',
);

const mockUser = User(
  id: '1',
  name: 'Test User',
  username: 'test',
  email: 'test@example.com',
  phone: '123',
  website: 'site.com',
  isAdmin: false,
  address: mockAddress,
  company: mockCompany,
);

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
        when(() => mockRepo.getUser(any())).thenAnswer((_) async => mockUser);
        return cubit;
      },
      act: (cubit) => cubit.loadUser('1'),
      expect: () => [
        const UserLoading(),
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
        // FIX: Wrapped to satisfy lines_longer_than_80_chars
        const UserFailure(
          'ServerFailure: 500 Internal Error',
        ),
      ],
    );
  });
}
