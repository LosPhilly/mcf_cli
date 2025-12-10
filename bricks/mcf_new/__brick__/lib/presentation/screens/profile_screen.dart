/*
 * Mission-Critical Flutter
 * Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter
 * License: MIT (see LICENSE file)
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name.snakeCase()}}/domain/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/presentation/cubit/user_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  // MCF Rule 4.7: Const constructor for performance optimization
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crew Member Status'),
        centerTitle: true,
      ),
      body: const _ProfileBody(), // Decomposed to keep build() pure and short
    );
  }
}

/// A private, dedicated widget for the body prevents the Scaffold
/// from rebuilding unnecessarily.
class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    // MCF Rule 2.3: Logic interaction only via BlocBuilder
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserInitial() => const SizedBox.shrink(),
          UserLoading() => const Center(child: CircularProgressIndicator()),
          UserFailure(message: final msg) => _ErrorDisplay(message: msg),
          UserLoaded(data: final user) => _CrewDataDisplay(user: user),
        };
      },
    );
  }
}

/// Displays the critical crew data.
/// MCF Rule 4.1: Stateless.
/// MCF Rule 2.1.2: No logic, just rendering data passed in via constructor.
class _CrewDataDisplay extends StatelessWidget {
  const _CrewDataDisplay({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // MCF Rule 4.7: Const used for static icon
            const Icon(Icons.person_pin, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 16),

            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '@${user.username}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
            ),

            const SizedBox(height: 16),

            // MCF Rule 4.4: Decomposed "Complex" UI element
            if (user.isAdmin) const _StatusBadge(label: 'COMMANDER'),

            const SizedBox(height: 32),

            // --- Section 1: Contact ---
            const _SectionHeader(title: 'CONTACT'),
            _ContactTile(icon: Icons.email, label: user.email),
            _ContactTile(icon: Icons.phone, label: user.phone),
            _ContactTile(icon: Icons.language, label: user.website),

            const Divider(indent: 32, endIndent: 32),

            // --- Section 2: Organization ---
            const _SectionHeader(title: 'ORGANIZATION'),
            _ContactTile(icon: Icons.business, label: user.company.name),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
              child: Text(
                '"${user.company.catchPhrase}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),

            const Divider(indent: 32, endIndent: 32),

            // --- Section 3: Location ---
            const _SectionHeader(title: 'LOCATION'),
            _ContactTile(
              icon: Icons.location_on,
              label: '${user.address.street}, ${user.address.city}',
            ),
            _ContactTile(
              icon: Icons.map,
              label:
                  'Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}',
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// --- Helper Components ---

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.blueGrey,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  const _ErrorDisplay({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          Text(
            'System Alert',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            // Logic Trigger: Loads User 1
            onPressed: () => context.read<UserCubit>().loadUser('1'),
            child: const Text('RETRY CONNECTION'),
          ),
        ],
      ),
    );
  }
}
