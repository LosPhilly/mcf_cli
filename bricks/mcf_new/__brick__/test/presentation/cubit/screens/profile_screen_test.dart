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

import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

class MockUserCubit extends MockCubit<UserState> implements UserCubit {}

void main() {
  testWidgets(
    'renders ErrorDisplay when state is UserFailure',
    (tester) async {
      final mockCubit = MockUserCubit();

      when(() => mockCubit.state).thenReturn(
        const UserFailure('System Down'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserCubit>.value(
            value: mockCubit,
            child: const UserProfileScreen(),
          ),
        ),
      );

      expect(find.text('System Alert'), findsOneWidget);
      expect(find.text('System Down'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
