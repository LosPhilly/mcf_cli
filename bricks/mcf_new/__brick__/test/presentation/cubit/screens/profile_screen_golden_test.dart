/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

/*
Important Note on Goldens
When a user runs this test for the first time, 
it will fail because the reference image (goldens/crew_display_commander.png) 
doesn't exist yet. They will need to run:
 flutter test --update-goldens


*/

import 'package:bloc_test/bloc_test.dart'; // REQUIRED
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Dynamic Imports for the generated project
import 'package:{{project_name.snakeCase()}}/domain/entities/address.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/company.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_state.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

// 1. Create a Mock Cubit
class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

// Mock Data
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
  testWidgets('Crew Display matches Golden File', (tester) async {
    // Set a consistent screen size for golden generation
    await tester.binding.setSurfaceSize(const Size(400, 800));

    // 2. Setup Mock
    final mockCubit = MockUserCubit();
    // Stub the state to "Loaded" so the UI renders the data
    when(() => mockCubit.state).thenReturn(const UserLoaded(mockCommanderUser));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
        home: BlocProvider<UserCubit>.value(
          // 3. Inject the Mock Here
          value: mockCubit,
          child: const UserProfileScreen(),
        ),
      ),
    );

    // MCF Rule 7.5: Verify pixel-perfect rendering
    await expectLater(
      find.byType(UserProfileScreen),
      matchesGoldenFile('goldens/crew_display_commander.png'),
    );
  });
}
