import 'package:flutter/material.dart';

import '../brand.dart';
import '../location.dart';
import '../model.dart';
import '../task_store.dart';
import 'admin_view.dart';
import 'worker_view.dart';

/// The landing screen. The two buttons stand in for Google sign-in in this proof of concept.
class LandingView extends StatelessWidget {
  const LandingView({super.key, required this.store, required this.location});
  final TaskStore store;
  final LocationService location;

  void _open(BuildContext context, Widget view) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => view));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Brand.green, Brand.greenDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Expanded(child: _Hero()),
              _RoleButton(
                icon: Icons.assignment_ind,
                label: 'Admin',
                background: Colors.white,
                foreground: Brand.greenDark,
                onPressed: () => _open(context, AdminView(store: store, location: location)),
              ),
              const SizedBox(height: 12),
              _RoleButton(
                icon: Icons.agriculture,
                label: 'Worker',
                background: Brand.wheat,
                foreground: Colors.white,
                onPressed: () => _open(
                  context,
                  WorkerView(store: store, location: location, person: worker),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (Brand.eventLogoAsset case final logo?)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Image.asset(logo, height: 96),
              ),
            const Icon(Icons.task_alt, color: Colors.white, size: 72),
            const SizedBox(height: 8),
            const Text(
              'Tasker',
              style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Today\'s farm work, simply.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 32),
            const Text(
              'Built at the San Diego AgTech Hackathon 2026\nSan Diego County Farm Bureau, Escondido',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFE6EFD9), fontSize: 15, height: 1.4),
            ),
          ]),
        ),
      );
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 76,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 36),
          label: Text(label, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        ),
      );
}
