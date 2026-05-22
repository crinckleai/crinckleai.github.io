import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase init is wrapped so the app still boots in unit/widget tests where
  // the platform plugin isn't available.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // ignored: lets developers run the app shell without firebase configured.
  }
  runApp(const ProviderScope(child: FlopFantasyApp()));
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
