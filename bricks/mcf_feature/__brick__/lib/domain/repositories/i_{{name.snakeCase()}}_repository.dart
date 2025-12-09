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