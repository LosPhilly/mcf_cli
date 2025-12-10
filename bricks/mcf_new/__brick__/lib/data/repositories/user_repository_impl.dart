/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:{{project_name.snakeCase()}}/data/models/user_model.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/failures/failure.dart';
import 'package:{{project_name.snakeCase()}}/domain/repositories/i_user_repository.dart';

Map<String, dynamic> _parseAndDecode(String responseBody) {
  return json.decode(responseBody) as Map<String, dynamic>;
}

class UserRepositoryImpl implements IUserRepository {
  UserRepositoryImpl({required this.client});

  final http.Client client;

  @override
  Future<User> getUser(String id) async {
    try {
      final response = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'FlightApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        try {
          final jsonMap = await compute(_parseAndDecode, response.body);
          return UserModel.fromJson(jsonMap);
        } catch (e) {
          throw FormatFailure('Data Parsing Failure: $e');
        }
      } else {
        throw ServerFailure('Server Error: ${response.statusCode}');
      }
    } on SocketException {
      throw const ConnectionFailure('No Internet Connection');
    }
  }

  @override
  Future<void> saveUser(User item) async {
    // FIX: Split long line to satisfy 80-char limit
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );
  }
}
