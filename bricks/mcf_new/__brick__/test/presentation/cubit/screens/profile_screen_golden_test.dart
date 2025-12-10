/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{project_name.snakeCase()}}/domain/entities/address.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/company.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

const mockCommanderUser = User(
  id: '1',
  name: 'Commander Shepard',
  username: 'shepard',
  email: 'shepard@alliance.mil',
  phone: '555-0199',
  website: 'alliance.mil',
  isAdmin: true,
  address: Address(
    street: 'Citadel',
    suite: 'Presidium',
    city: 'Space',
    zipcode: '00000',
    geo: Geo(lat: '0', lng: '0'),
  ),
  company: Company(
    name: 'Systems Alliance',
    catchPhrase: 'Protecting Humanity',
    bs: 'defense',
  ),
);

void main() {
  testWidgets('Crew Display smoke test', (tester) async {
    final mockCubit = MockUserCubit();
    when(() => mockCubit.state).thenReturn(const UserLoaded(mockCommanderUser));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserProfileScreen(),
        ),
      ),
    );

    // FIX: Allow the widget frame to settle
    await tester.pumpAndSettle();

    // Verification: Does the screen load without crashing?
    expect(find.byType(UserProfileScreen), findsOneWidget);
  });
}
