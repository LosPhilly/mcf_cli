part of '{{name.snakeCase()}}_cubit.dart';

sealed class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State();

  @override
  List<Object> get props => [];
}

class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Initial();
}

class {{name.pascalCase()}}Loading extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}Loading();
}

class {{name.pascalCase()}}Loaded extends {{name.pascalCase()}}State {
  final {{name.pascalCase()}} data;

  const {{name.pascalCase()}}Loaded(this.data);

  @override
  List<Object> get props => [data];
}

class {{name.pascalCase()}}Failure extends {{name.pascalCase()}}State {
  final String message;

  const {{name.pascalCase()}}Failure(this.message);

  @override
  List<Object> get props => [message];
}