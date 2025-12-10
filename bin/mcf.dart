/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * CLI Entry Point
 */

import 'dart:io';
import 'package:args/args.dart';

// CONFIGURATION
const String _repoUrl = 'https://github.com/LosPhilly/mcf_cli';
const String _brickPathNew = 'bricks/mcf_new';
const String _brickPathFeature = 'bricks/mcf_feature';

void main(List<String> arguments) async {
  // 1. Ensure Mason exists
  await _ensureMasonIsInstalled();

  final parser = ArgParser()
    ..addCommand('new')
    ..addCommand('feature')
    ..addCommand('audit');

  var results = parser.parse(arguments);

  // 2. Global Error Handling
  try {
    if (results.command?.name == 'new') {
      await _ensureBrickInstalled('mcf_new', _brickPathNew);

      // SAFETY CHECK: Get the correct project name to prevent "erasing" the app
      final projectName = _detectProjectName() ?? 'my_app';
      print('🚀 Initializing Mission-Critical Project: $projectName');

      await _runMasonCommand([
        'make',
        'mcf_new',
        '--project_name',
        projectName,
        '--on-conflict',
        'overwrite'
      ]);
    } else if (results.command?.name == 'feature') {
      await _ensureBrickInstalled('mcf_feature', _brickPathFeature);
      print('🧩 Generating Vertical Slice...');
      await _runMasonCommand(
          ['make', 'mcf_feature', ...results.command!.arguments]);
    } else if (results.command?.name == 'audit') {
      print('🔍 Running Compliance Audit...');
      // Audit handles its own exit codes now
      await _runAudit();
    } else {
      _printUsage();
    }
  } catch (e) {
    // Graceful exit for known errors (avoids stack trace spam)
    if (e is! ProcessException) {
      print('❌ Error: $e');
    }
    exit(1);
  }
}

/// SMART FIX: Reads the current pubspec.yaml to find the REAL project name.
String? _detectProjectName() {
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    try {
      final lines = pubspecFile.readAsLinesSync();
      for (var line in lines) {
        if (line.trim().startsWith('name:')) {
          return line.split(':')[1].trim();
        }
      }
    } catch (e) {
      // Ignore errors reading file
    }
  }
  return null;
}

Future<void> _runMasonCommand(List<String> args) async {
  try {
    await _runInteractive('mason', args);
  } catch (e) {
    await _runInteractive(
        'dart', ['pub', 'global', 'run', 'mason_cli:mason', ...args]);
  }
}

Future<void> _ensureMasonIsInstalled() async {
  try {
    await Process.run('mason', ['--version'], runInShell: true);
  } catch (e) {
    print('⚠️ Mason CLI not found. Installing it for you...');
    final result = await Process.run(
        'dart', ['pub', 'global', 'activate', 'mason_cli'],
        runInShell: true);
    if (result.exitCode != 0) exit(1);
  }
}

Future<void> _ensureBrickInstalled(String brickName, String gitPath) async {
  try {
    final check = await Process.run('mason', ['list'], runInShell: true);
    if (!check.stdout.toString().contains(brickName)) {
      throw ProcessException('mason', ['list']);
    }
  } catch (e) {
    print('📦 Installing $brickName template from GitHub...');
    await _runMasonCommand([
      'add',
      brickName,
      '--git-url',
      _repoUrl,
      '--git-path',
      gitPath,
      '--global'
    ]);
  }
}

Future<void> _runInteractive(String cmd, List<String> args) async {
  final process = await Process.start(cmd, args,
      runInShell: true, mode: ProcessStartMode.inheritStdio);
  final code = await process.exitCode;
  // This throws if exit code is non-zero (like when audit fails)
  if (code != 0) throw ProcessException(cmd, args, 'Exit Code $code');
}

Future<void> _runAudit() async {
  if (File('tool/audit.dart').existsSync()) {
    try {
      await _runInteractive('dart', ['run', 'tool/audit.dart']);
    } catch (e) {
      // CATCH: The audit failed. We exit(1) to signal CI/CD failure,
      // but we suppress the stack trace because the audit tool already printed the errors.
      exit(1);
    }
  } else {
    print('❌ Audit tool not found.');
  }
}

void _printUsage() {
  print('Mission-Critical Flutter CLI v1.0.9');
  print('Usage: mcf <command> [arguments]');
}
