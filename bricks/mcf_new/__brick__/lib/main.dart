/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:{{project_name.snakeCase()}}/data/repositories/user_repository_impl.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';
import 'package:{{project_name.snakeCase()}}/presentation/screens/profile_screen.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      final httpClient = http.Client();
      final userRepository = UserRepositoryImpl(client: httpClient);

      runApp(MissionCriticalApp(userRepository: userRepository));
    },
    (error, stackTrace) {
      log(
        'CRITICAL: Uncaught Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      // TODO(dev): Report to Crashlytics
    },
  );
}

class MissionCriticalApp extends StatelessWidget {
  const MissionCriticalApp({
    required this.userRepository,
    super.key,
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
      home: BlocProvider(
        create: (context) => UserCubit(userRepository)..loadUser('1'),
        child: const UserProfileScreen(),
      ),
    );
  }
}
