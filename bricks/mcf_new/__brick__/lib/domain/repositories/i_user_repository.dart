/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/failures/failure.dart';

/// Contract for User data operations.
/// Rule 2.2: Presentation Layer depends on interface, not implementation.
abstract class IUserRepository {
  /// Fetches the User data.
  /// Throws [Failure] on error.
  Future<User> getUser(String id);

  /// Saves the User.
  Future<void> saveUser(User item);
}
