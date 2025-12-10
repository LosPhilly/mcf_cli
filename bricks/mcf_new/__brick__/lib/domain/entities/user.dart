/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'package:{{project_name.snakeCase()}}/domain/entities/address.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/company.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.isAdmin,
    required this.address,
    required this.company,
  });

  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final bool isAdmin;

  // Complex Types
  final Address address;
  final Company company;
}
