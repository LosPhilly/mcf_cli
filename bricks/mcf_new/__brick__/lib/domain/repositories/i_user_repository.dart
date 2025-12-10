/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/failures/failure.dart';

/// Contract for User data operations.
/// MCF Rule 2.2: The Presentation Layer depends on this interface, not the implementation.
abstract class IUserRepository {
  /// Fetches the User data.
  /// Throws [Failure] on error.
  Future<User> getUser(String id);

  /// Saves the User.
  Future<void> saveUser(User item);
}
