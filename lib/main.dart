import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap.dart';
import 'core/router/router_provider.dart';
import 'core/services/sound_service.dart';
import 'core/theme/app_theme.dart';
import 'core/di/core_providers.dart';

void main() async {
  // Use bootstrap for initialization
  await bootstrap();

  // Initialize sound service (keep this until F5/Sound refactor is fully integrated)
  final soundService = SoundService();
  await soundService.initialize();

  runApp(
    ProviderScope(
      overrides: [soundServiceProvider.overrideWithValue(soundService)],
      child: const TomadoroApp(),
    ),
  );
}

class TomadoroApp extends ConsumerWidget {
  const TomadoroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tomadoro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
