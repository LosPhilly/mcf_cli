/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * CLI Entry Point
 */

import 'dart:io';
import 'package:args/args.dart';

// CONFIGURATION
const String _repoUrl = 'https://github.com/LosPhilly/mission-critical-flutter';
// Adjust this path if your bricks are in a different subfolder in your repo
const String _brickPathNew = 'mcf_cli/bricks/mcf_new';
const String _brickPathFeature = 'mcf_cli/bricks/mcf_feature';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('new')
    ..addCommand('feature')
    ..addCommand('audit');

  var results = parser.parse(arguments);

  if (results.command?.name == 'new') {
    await _ensureBrickInstalled('mcf_new', _brickPathNew);
    print('🚀 Initializing Mission-Critical Project...');
    await _runMason(['make', 'mcf_new', ...results.command!.arguments]);
  } else if (results.command?.name == 'feature') {
    await _ensureBrickInstalled('mcf_feature', _brickPathFeature);
    print('🧩 Generating Vertical Slice...');
    await _runMason(['make', 'mcf_feature', ...results.command!.arguments]);
  } else if (results.command?.name == 'audit') {
    print('🔍 Running Compliance Audit...');
    await _runAudit();
  } else {
    _printUsage();
  }
}

/// Installs the brick from GitHub if it's missing from the user's machine.
Future<void> _ensureBrickInstalled(String brickName, String gitPath) async {
  // Check if brick exists locally
  final check = await Process.run('mason', ['list'], runInShell: true);
  if (!check.stdout.toString().contains(brickName)) {
    print('📦 Installing $brickName template from GitHub...');
    final result = await Process.run(
        'mason',
        [
          'add',
          brickName,
          '--git-url',
          _repoUrl,
          '--git-path',
          gitPath,
          '--global'
        ],
        runInShell: true);

    if (result.exitCode != 0) {
      print('❌ Failed to install brick: ${result.stderr}');
      exit(1);
    }
  }
}

Future<void> _runMason(List<String> args) async {
  final process = await Process.start('mason', args,
      runInShell: true,
      mode: ProcessStartMode
          .inheritStdio // This lets the user interact with prompts
      );
  await process.exitCode;
}

Future<void> _runAudit() async {
  // Check if the audit tool exists in the current project
  if (File('tool/audit.dart').existsSync()) {
    final process = await Process.start('dart', ['run', 'tool/audit.dart'],
        runInShell: true, mode: ProcessStartMode.inheritStdio);
    await process.exitCode;
  } else {
    print('❌ Audit tool not found.');
    print('   Run this command inside the root of an MCF project.');
  }
}

void _printUsage() {
  print('Mission-Critical Flutter CLI v1.0.0');
  print('Usage: mcf <command> [arguments]');
  print('\nAvailable commands:');
  print('  new      Create a new project');
  print('  feature  Generate a new feature');
  print('  audit    Run compliance checks');
}
