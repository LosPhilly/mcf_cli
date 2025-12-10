/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Dynamic Imports
import 'package:{{project_name.snakeCase()}}/data/repositories/user_repository_impl.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

// MCF Rule 5.7: Composition Root
// This file assembles the app. No logic allowed here.

void main() {
  // MCF Rule 6.4: Global Error Boundary
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. Initialize Infrastructure
      final httpClient = http.Client();

      // 2. Initialize Repositories (Data Layer)
      final userRepository = UserRepositoryImpl(client: httpClient);

      runApp(MissionCriticalApp(userRepository: userRepository));
    },
    (error, stackTrace) {
      log('CRITICAL: Uncaught Error: $error',
          error: error, stackTrace: stackTrace);
      // TODO: Report to Crashlytics
    },
  );
}

class MissionCriticalApp extends StatelessWidget {
  const MissionCriticalApp({
    super.key,
    required this.userRepository,
  });

  final UserRepositoryImpl userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{project_name.titleCase()}}',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      // 3. Inject Logic (Presentation Layer)
      home: BlocProvider(
        create: (context) => UserCubit(userRepository)..loadUser('1'),
        child: const UserProfileScreen(),
      ),
    );
  }
}
