import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/home_screen.dart';
import '../ui/screens/live_tracker_screen.dart';
import '../ui/screens/transfer_market_screen.dart';
import '../ui/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/market',
            pageBuilder: (_, __) => const NoTransitionPage(child: TransferMarketScreen()),
          ),
          GoRoute(
            path: '/live',
            pageBuilder: (_, __) => const NoTransitionPage(child: LiveTrackerScreen()),
          ),
        ],
      ),
    ],
  );
});
