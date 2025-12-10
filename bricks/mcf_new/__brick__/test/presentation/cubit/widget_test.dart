// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:{{project_name.snakeCase()}}/main.dart';
import 'package:{{project_name.snakeCase()}}/data/repositories/user_repository_impl.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // FIX: Using MissionCriticalApp instead of MyApp
    // FIX: Injecting required repository
    await tester.pumpWidget(MissionCriticalApp(
      userRepository: UserRepositoryImpl(client: http.Client()),
    ));

    // Verify that the standby message is shown.
    expect(find.text('System Standby. Initialize Data.'), findsOneWidget);
  });
}
