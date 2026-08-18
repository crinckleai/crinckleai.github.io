import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;

  static const _tabs = [
    _Tab(path: '/', icon: Icons.sports_soccer, label: 'PITCH'),
    _Tab(path: '/market', icon: Icons.local_grocery_store, label: 'MARKET'),
    _Tab(path: '/live', icon: Icons.bolt, label: 'LIVE'),
  ];

  @override
  Widget build(BuildContext context) {
    final index = _tabs.indexWhere((t) => t.path == location).clamp(0, _tabs.length - 1);
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => context.go(_tabs[i].path),
          items: [
            for (final t in _tabs)
              BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
          ],
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.path, required this.icon, required this.label});
  final String path;
  final IconData icon;
  final String label;
}
