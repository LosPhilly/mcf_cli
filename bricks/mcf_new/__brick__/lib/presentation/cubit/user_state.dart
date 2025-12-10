/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
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
  const UserLoaded(this.data);

  final User data;

  @override
  List<Object> get props => [data];
}

class UserFailure extends UserState {
  const UserFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
