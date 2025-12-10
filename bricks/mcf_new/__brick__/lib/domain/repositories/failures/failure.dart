/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

// The abstract contract for all logic failures
abstract class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// Specific failure types for the Logic/UI to react to
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

// Added to handle JSON parsing/Type errors safely
class FormatFailure extends Failure {
  const FormatFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
