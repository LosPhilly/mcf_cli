/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * This file is part of the "Mission-Critical Flutter" reference implementation.
 * It strictly adheres to the architectural rules defined in the book.
 * Author: Carlos Phillips
 * License: MIT (see LICENSE file)
 */

part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User data;

  const UserLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);

  @override
  List<Object> get props => [message];
}
