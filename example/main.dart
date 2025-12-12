/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'dart:io';

/// This example simulates the standard workflow of upgrading a vanilla
/// Flutter project to the Mission-Critical Architecture.
///
/// It demonstrates the CLI's ability to detect incompatible default files
/// (like widget_test.dart) and enforce forensic-grade compliance.
void main() {
  print('===============================================================');
  print('   MISSION-CRITICAL FLUTTER CLI (mcf) - WORKFLOW SIMULATION    ');
  print('===============================================================');
  print('');

  // ----------------------------------------------------------------------
  // SCENARIO: A developer starts with a standard, unsafe Flutter app.
  // ----------------------------------------------------------------------
  print('STEP 1: Create a standard Flutter App');
  print('-------------------------------------');
  print('\$ flutter create flight_app');
  print('  Creating project flight_app...');
  print('  Wrote 130 files.');
  print('  All done!');
  print('');

  // ----------------------------------------------------------------------
  // SCENARIO: They run 'mcf new' to inject the architecture.
  // ----------------------------------------------------------------------
  print('STEP 2: Upgrade to Forensic-Grade Architecture');
  print('----------------------------------------------');
  print('\$ cd flight_app');
  print('\$ mcf new flight_app');
  print('');
  print('  📦 Installing mcf_new template...');
  print('  🚀 Initializing Mission-Critical Project: flight_app');
  print('  ? What is the organization? (com.example) com.alliance');
  print('');

  // Highlight: Intelligent overwrite protection for incompatible files
  print('  ⚠️  Conflict detected: test/widget_test.dart');
  print(
      '      (The default Flutter test is incompatible with MCF Architecture)');
  print('  ? Overwrite widget_test.dart? (Y/n) Y');
  print('');
  print('  ✓ Generated 23 files. (0.4s)');
  print('    - Replaced lib/main.dart (Dependency Injection Setup)');
  print('    - Replaced test/widget_test.dart (Fixed Test)');
  print('    - Created Clean Architecture Layers (Domain, Data, Presentation)');
  print('');

  // ----------------------------------------------------------------------
  // SCENARIO: They run 'mcf audit' to verify system integrity.
  // ----------------------------------------------------------------------
  print('STEP 3: Verify Compliance');
  print('-------------------------');
  print('\$ mcf audit');
  print('  🔍 Running Compliance Audit...');
  print('');
  print('  [PHASE 1] Static Pattern Analysis');
  print('   ✓ Domain Layer Isolation (Rule 2.2)');
  print('   ✓ Pure Logic Verification (Rule 2.4)');
  print('   ✓ Build Method Complexity (Rule 2.5)');
  print('   ✓ Safety Checks (No Bang Operator)');
  print('');
  print('  [PHASE 2] Toolchain Verification');
  print('   ✓ Linter Compliance (Strict Mode)');
  print('   ✓ Test Suite Verification');
  print('');
  print('  ✓ AUDIT PASSED. SYSTEM SECURE.');
  print('');

  exit(0);
}
