/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import '../entities/{{name.snakeCase()}}.dart';
import '../failures/failure.dart';

/// Contract for {{name.pascalCase()}} data operations.
/// MCF Rule 2.2: The Presentation Layer depends on this interface, not the implementation.
abstract class I{{name.pascalCase()}}Repository {
  
  /// Fetches the {{name.pascalCase()}} data.
  /// Throws [Failure] on error.
  Future<{{name.pascalCase()}}> get{{name.pascalCase()}}(String id);

  /// Saves the {{name.pascalCase()}}.
  Future<void> save{{name.pascalCase()}}({{name.pascalCase()}} item);
}