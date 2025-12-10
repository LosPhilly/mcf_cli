/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:bloc_test/bloc_test.dart'; // Provides MockCubit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Dynamic Imports for the generated project
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

// FIX: Extend 'MockCubit' (singular), not 'MockCubits'.
class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

void main() {
  testWidgets('renders ErrorDisplay when state is UserFailure', (tester) async {
    // Arrange
    final mockCubit = MockUserCubit();

    // Stub the state to return UserFailure immediately
    // Note: We use UserFailure here, not UserError, matching your user_state.dart
    when(() => mockCubit.state).thenReturn(
      const UserFailure('System Down'),
    );

    // Act: Pump the widget tree with the Mock Cubit injected
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCubit>.value(
          value: mockCubit,
          child: const UserProfileScreen(),
        ),
      ),
    );

    // Assert: Verify the specific UI component appears
    expect(find.text('System Alert'), findsOneWidget);
    expect(find.text('System Down'), findsOneWidget);

    // Ensure the loading spinner is GONE
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
