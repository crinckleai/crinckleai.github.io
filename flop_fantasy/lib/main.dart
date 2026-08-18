import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'state/providers.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Try to initialise Firebase. If it fails (no config, demo runs, etc.) we
  // fall back to demo mode so the UI still renders populated screens.
  var firebaseUp = false;
  try {
    await Firebase.initializeApp();
    firebaseUp = true;
  } catch (_) {
    firebaseUp = false;
  }
  runApp(
    ProviderScope(
      overrides: [
        demoModeProvider.overrideWith((_) => !firebaseUp),
      ],
      child: const FlopFantasyApp(),
    ),
  );
}

class FlopFantasyApp extends ConsumerWidget {
  const FlopFantasyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Flop Fantasy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
