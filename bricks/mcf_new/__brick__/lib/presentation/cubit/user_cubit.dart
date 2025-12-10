/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final IUserRepository _repository;

  UserCubit(this._repository) : super(const UserInitial());

  Future<void> loadUser(String id) async {
    // MCF Rule 6.6: Reentrancy Guard
    // Prevents double-loading if the user taps multiple times.
    if (state is UserLoading) return;

    emit(const UserLoading());

    try {
      final result = await _repository.getUser(id);
      emit(UserLoaded(result));
    } catch (e) {
      // In a real app, you would map 'e' to a Domain Failure here
      emit(UserFailure(e.toString()));
    }
  }
}
