import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/i_{{name.snakeCase()}}_repository.dart';
import '../../domain/entities/{{name.snakeCase()}}.dart';

part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  final I{{name.pascalCase()}}Repository _repository;

  {{name.pascalCase()}}Cubit(this._repository) : super(const {{name.pascalCase()}}Initial());

  Future<void> load{{name.pascalCase()}}(String id) async {
    // MCF Rule 6.6: Reentrancy Guard
    // Prevents double-loading if the user taps multiple times.
    if (state is {{name.pascalCase()}}Loading) return;

    emit(const {{name.pascalCase()}}Loading());

    try {
      final result = await _repository.get{{name.pascalCase()}}(id);
      emit({{name.pascalCase()}}Loaded(result));
    } catch (e) {
      emit({{name.pascalCase()}}Failure(e.toString()));
    }
  }
}