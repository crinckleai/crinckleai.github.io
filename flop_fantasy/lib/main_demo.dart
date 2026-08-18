import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'state/providers.dart';
import 'theme/app_theme.dart';

/// Alternate entrypoint for offline/demo runs. Skips the Firebase plugin
/// entirely so the app can render without network access. Build with:
///   flutter build web --release --target lib/main_demo.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [demoModeProvider.overrideWith((_) => true)],
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
