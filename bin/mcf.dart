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
  await _ensureMasonIsInstalled();

  final parser = ArgParser()
    ..addCommand('new')
    ..addCommand('feature')
    ..addCommand('audit');

  var results = parser.parse(arguments);

  if (results.command?.name == 'new') {
    await _ensureBrickInstalled('mcf_new', _brickPathNew);
    print('🚀 Initializing Mission-Critical Project...');
    // Use the robust helper
    await _runMasonCommand([
      'make',
      'mcf_new',
      '--on-conflict',
      'overwrite',
      ...results.command!.arguments
    ]);
  } else if (results.command?.name == 'feature') {
    await _ensureBrickInstalled('mcf_feature', _brickPathFeature);
    print('🧩 Generating Vertical Slice...');
    await _runMasonCommand(
        ['make', 'mcf_feature', ...results.command!.arguments]);
  } else if (results.command?.name == 'audit') {
    print('🔍 Running Compliance Audit...');
    await _runAudit();
  } else {
    _printUsage();
  }
}

/// Tries to run 'mason'. If Windows can't find it, falls back to 'dart pub global run mason_cli:mason'.
Future<void> _runMasonCommand(List<String> args) async {
  try {
    // Attempt 1: Standard Command
    await _runInteractive('mason', args);
  } catch (e) {
    // Attempt 2: Direct Execution (Bypasses PATH issues on Windows)
    await _runInteractive(
        'dart', ['pub', 'global', 'run', 'mason_cli:mason', ...args]);
  }
}

Future<void> _ensureMasonIsInstalled() async {
  try {
    // Quietly check if we can run mason
    await Process.run('mason', ['--version'], runInShell: true);
  } catch (e) {
    print('⚠️ Mason CLI not found. Installing it for you...');

    final result = await Process.run(
        'dart', ['pub', 'global', 'activate', 'mason_cli'],
        runInShell: true);

    if (result.exitCode != 0) {
      print(
          '❌ Failed to install Mason. Please run: "dart pub global activate mason_cli" manually.');
      exit(1);
    }
    print('✅ Mason installed successfully.');
  }
}

Future<void> _ensureBrickInstalled(String brickName, String gitPath) async {
  try {
    // We use a separate check here because we need to parse the output
    final result = await Process.run('mason', ['list'], runInShell: true);
    final output = result.stdout.toString();

    // If the command failed OR the brick isn't listed
    if (result.exitCode != 0 || !output.contains(brickName)) {
      throw ProcessException('mason', ['list']); // Trigger the catch block
    }
  } catch (e) {
    print('📦 Installing $brickName template from GitHub...');
    // Use the robust runner to install the brick
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
  if (code != 0) {
    // We throw an exception so the caller knows to try the fallback method
    throw ProcessException(cmd, args, 'Process failed with exit code $code');
  }
}

Future<void> _runAudit() async {
  if (File('tool/audit.dart').existsSync()) {
    await _runInteractive('dart', ['run', 'tool/audit.dart']);
  } else {
    print('❌ Audit tool not found.');
    print('   Run this command inside the root of an MCF project.');
  }
}

void _printUsage() {
  print('Mission-Critical Flutter CLI v1.0.6');
  print('Usage: mcf <command> [arguments]');
  print('\nAvailable commands:');
  print('  new      Create a new project');
  print('  feature  Generate a new feature');
  print('  audit    Run compliance checks');
}
