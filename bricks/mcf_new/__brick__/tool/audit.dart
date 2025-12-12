/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * Audit Tool v3.0 (Strict Compliance)
 * * USAGE:
 * dart run tool/audit.dart
 */

import 'dart:io';

// ----------------------------------------------------------------------------
// CONFIGURATION & THRESHOLDS
// ----------------------------------------------------------------------------
const int _maxBuildLines = 40; [cite_start]// MCF Rule 2.5 [cite: 150]

// ANSI Colors for Terminal Output
const String _reset = '\x1B[0m';
const String _red = '\x1B[31m';
const String _green = '\x1B[32m';
const String _yellow = '\x1B[33m';
const String _cyan = '\x1B[36m';
const String _bold = '\x1B[1m';

void main() async {
  print('$_cyan$_bold[ MCF ARCHITECTURE AUDIT v3.0 ]$_reset');
  print('Initializing Mission-Critical Compliance Pipeline...\n');

  int violations = 0;
  final currentDir = Directory.current;

  // --- PHASE 1: STATIC CODE ANALYSIS ---
  print('$_bold[PHASE 1] Static Pattern Analysis$_reset');

  // 1. CHECK: Analysis Options Config (Rule 3.1)
  violations += await _verifyAnalysisOptions(currentDir);

  // 2. CHECK: Layer Isolation (Rule 2.2)
  // Ensures Domain never imports Data or Presentation.
  violations += await _verifyLayerIsolation(currentDir);

  // 3. CHECK: Pure Logic Isolation (Rule 2.4) - NEW
  // Ensures Cubits/Blocs do not import UI code (material/cupertino).
  violations += await _verifyLogicIsolation(currentDir);

  // 4. CHECK: The "Bang" Operator (Rule 3.4)
  // Prohibits force-unwrapping (!).
  violations += await _verifyNoBangOperator(currentDir);

  // 5. CHECK: Widget Build Complexity (Rule 2.5) - NEW
  // Heuristic check for build() methods > 40 lines.
  violations += await _verifyBuildMethodSize(currentDir);

  // 6. CHECK: Branding
  violations += await _verifyHeaders(currentDir);

  // --- PHASE 2: TOOLCHAIN VERIFICATION ---
  print('\n$_bold[PHASE 2] Toolchain Verification$_reset');

  // 7. CHECK: Flutter Analyzer
  // Verifies Rule 3.3 (No dynamic) & Rule 4.1 (Stateless preference) via linter
  if (!await _runFlutterCommand('analyze', 'Linter Compliance')) {
    violations++;
  }

  // 8. CHECK: Testing (Rule 7.1 - 7.3)
  if (!await _runFlutterCommand('test', 'Test Suite Verification')) {
    violations++;
  }

  print('\n---------------------------------------------------');
  if (violations == 0) {
    print('$_green$_bold✓ AUDIT PASSED. SYSTEM SECURE.$_reset');
    exit(0);
  } else {
    print('$_red$_bold✖ AUDIT FAILED.$_reset');
    print('$_yellow$violations Violation(s) Detected.$_reset');
    print('Review the logs above and refactor code to comply with MCF Standards.');
    exit(1);
  }
}

// ----------------------------------------------------------------------------
// RULE CHECKERS
// ----------------------------------------------------------------------------

// Rule 2.4 (Should): Logic classes (Bloc/Cubit) should not import UI framework classes.
[cite_start]// [cite: 146]
Future<int> _verifyLogicIsolation(Directory root) async {
  stdout.write('Verifying Logic (Cubit/Bloc) Isolation... ');
  final libDir = Directory('${root.path}/lib');
  
  if (!await libDir.exists()) return 0;

  int violations = 0;
  bool headerPrinted = false;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && 
       (entity.path.endsWith('_cubit.dart') || entity.path.endsWith('_bloc.dart'))) {
      
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (var line in lines) {
        final trimmed = line.trim();
        // Check for UI imports. 
        // Note: 'foundation' is allowed for @immutable, but material/cupertino/widgets are banned.
        if (trimmed.startsWith('import') && 
           (trimmed.contains('package:flutter/material.dart') || 
            trimmed.contains('package:flutter/cupertino.dart') ||
            trimmed.contains('package:flutter/widgets.dart'))) {
          
          if (!headerPrinted) {
            print('');
            headerPrinted = true;
          }
          print('  $_red[VIOLATION] ${entity.uri.pathSegments.last}$_reset');
          print('   -> Logic class importing UI (Rule 2.4): "$trimmed"');
          print('   -> Fix: Move UI-specific logic to the Widget or use a primitive type.');
          violations++;
        }
      }
    }
  }

  if (violations == 0) {
    print('$_green[PASS]$_reset');
  }
  return violations;
}

// Rule 2.5 (Will): Build methods should be short (<40 lines).
[cite_start]// [cite: 150]
Future<int> _verifyBuildMethodSize(Directory root) async {
  stdout.write('Scanning Build Method Complexity... ');
  final libDir = Directory('${root.path}/lib');
  int violations = 0;
  bool headerPrinted = false;

  if (!await libDir.exists()) return 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
       final content = await entity.readAsString();
       // Only scan files that look like Widgets
       if (!content.contains('extends StatelessWidget') && !content.contains('State<')) continue;

       final lines = content.split('\n');
       
       for (int i = 0; i < lines.length; i++) {
         if (lines[i].contains('Widget build(BuildContext context)')) {
           int braceCount = 0;
           bool foundStart = false;
           
           // Heuristic: Count braces to find the end of the method
           for (int j = i; j < lines.length; j++) {
             final line = lines[j];
             braceCount += line.split('{').length - 1;
             braceCount -= line.split('}').length - 1;
             
             if (line.contains('{')) foundStart = true;

             if (foundStart && braceCount <= 0) {
               final methodLength = j - i;
               
               // Buffer of 5 lines allowed for signature/closing braces
               if (methodLength > (_maxBuildLines + 5)) {
                 if (!headerPrinted) { print(''); headerPrinted = true; }
                 print('  $_yellow[WARNING] ${entity.uri.pathSegments.last}$_reset');
                 print('   -> build() method is $methodLength lines. Limit is $_maxBuildLines (Rule 2.5).');
                 print('   -> Fix: Extract sub-widgets into separate classes.');
                 violations++;
               }
               break; // Move to next file or method (simplified to one per file for speed)
             }
           }
         }
       }
    }
  }

  if (violations == 0) {
    print('$_green[PASS]$_reset');
  }
  return violations;
}

// Rule 2.2 (Shall): Domain Isolation
[cite_start]// [cite: 118-121]
Future<int> _verifyLayerIsolation(Directory root) async {
  stdout.write('Verifying Domain Layer Isolation... ');
  final domainDir = Directory('${root.path}/lib/domain');

  if (!await domainDir.exists()) {
    print('$_yellow[SKIP]$_reset (No domain folder)');
    return 0;
  }

  int violations = 0;
  bool headerPrinted = false;

  await for (final entity in domainDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('import')) {
          final importsLayers = trimmed.contains('/data/') || trimmed.contains('/presentation/');
          final importsFlutter = trimmed.contains('package:flutter/') && !trimmed.contains('foundation.dart');
          final importsPlatform = trimmed.contains('dart:io') || trimmed.contains('dart:html') || trimmed.contains('dart:ui');

          if (importsLayers || importsFlutter || importsPlatform) {
            if (!headerPrinted) { print(''); headerPrinted = true; }
            print('  $_red[VIOLATION] ${entity.uri.pathSegments.last}$_reset');
            print('   -> Forbidden import (Rule 2.2): "$trimmed"');
            violations++;
          }
        }
      }
    }
  }

  if (violations == 0) print('$_green[PASS]$_reset');
  return violations;
}

// Rule 3.4 (Shall): No Bang Operator
[cite_start]// [cite: 529]
Future<int> _verifyNoBangOperator(Directory root) async {
  stdout.write('Scanning for Bang Operator (!)... ');
  final libDir = Directory('${root.path}/lib');
  int violations = 0;
  bool headerPrinted = false;

  if (!await libDir.exists()) return 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (entity.path.endsWith('.g.dart') || entity.path.endsWith('.freezed.dart')) continue;

      final lines = await entity.readAsLines();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('!') && !line.contains('!=') && !line.trim().startsWith('//')) {
          if (!line.contains('!mounted')) { // Exception for mounted checks
            if (!headerPrinted) { print(''); headerPrinted = true; }
            print('  $_red[VIOLATION] ${entity.uri.pathSegments.last}:${i + 1}$_reset');
            print('   -> Unsafe Bang Operator (Rule 3.4): "${line.trim()}"');
            violations++;
          }
        }
      }
    }
  }

  if (violations == 0) print('$_green[PASS]$_reset');
  return violations;
}

// Rule 3.1 (Shall): Analysis Config
[cite_start]// [cite: 514-516]
Future<int> _verifyAnalysisOptions(Directory root) async {
  stdout.write('Checking analysis_options.yaml... ');
  final file = File('${root.path}/analysis_options.yaml');

  if (!await file.exists()) {
    print('$_red[MISSING]$_reset');
    return 1;
  }

  final content = await file.readAsString();
  int errors = 0;

  if (!content.contains('strict-casts: true')) errors++;
  if (!content.contains('strict-inference: true')) errors++;
  if (!content.contains('avoid_dynamic_calls: error') && !content.contains('avoid_dynamic_calls: true')) errors++;

  if (errors > 0) {
    print('$_red[FAILED]$_reset (Missing strict rules - see Rule 3.1)');
    return 1;
  }

  print('$_green[PASS]$_reset');
  return 0;
}

Future<int> _verifyHeaders(Directory root) async {
  stdout.write('Verifying Copyright Headers... ');
  final libDir = Directory('${root.path}/lib');
  int violations = 0;

  if (!await libDir.exists()) return 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      if (!content.contains('Mission-Critical Flutter')) violations++;
    }
  }

  if (violations > 0) {
    print('$_yellow[WARN]$_reset');
    print('  -> $violations files missing MCF Copyright Header.');
    return 0; // Warning only
  }

  print('$_green[PASS]$_reset');
  return 0;
}

// ----------------------------------------------------------------------------
// UTILITIES
// ----------------------------------------------------------------------------

Future<bool> _runFlutterCommand(String command, String label) async {
  stdout.write('Running $label (flutter $command)... ');
  final result = await Process.run('flutter', [command], runInShell: true);

  if (result.exitCode == 0) {
    print('$_green[PASS]$_reset');
    return true;
  } else {
    print('$_red[FAIL]$_reset');
    final lines = result.stdout.toString().split('\n');
    for (var i = 0; i < (lines.length > 5 ? 5 : lines.length); i++) {
      if (lines[i].trim().isNotEmpty) print('  > ${lines[i]}');
    }
    return false;
  }
}