/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._repository) : super(const UserInitial());

  final IUserRepository _repository;

  Future<void> loadUser(String id) async {
    if (state is UserLoading) {
      return;
    }

    emit(const UserLoading());

    try {
      final result = await _repository.getUser(id);
      emit(UserLoaded(result));
    } on Exception catch (e) {
      emit(UserFailure(e.toString()));
    } on Object catch (e) {
      // FIX: Use 'on Object' to satisfy avoid_catches_without_on_clauses
      emit(UserFailure(e.toString()));
    }
  }
}
