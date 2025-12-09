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

// MCF Rule 5.7: Composition Root
// This file assembles the app. No logic allowed here.

void main() {
  // MCF Rule 6.4: Global Error Boundary
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // TODO: Inject Dependencies here
      // final repo = MyRepositoryImpl();

      runApp(const MissionCriticalApp());
    },
    (error, stackTrace) {
      log('CRITICAL: Uncaught Error: $error',
          error: error, stackTrace: stackTrace);
      // TODO: Report to Crashlytics
    },
  );
}

class MissionCriticalApp extends StatelessWidget {
  const MissionCriticalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{project_name.titleCase()}}',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const Scaffold(
        body: Center(child: Text('MCF Architecture Ready')),
      ),
    );
  }
}
