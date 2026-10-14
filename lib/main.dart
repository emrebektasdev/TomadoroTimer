import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap.dart';
import 'core/storage/account_gate.dart';
import 'features/user/application/user_providers.dart';
import 'core/router/router_provider.dart';
import 'core/services/sound_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Use bootstrap for initialization
  await bootstrap();

  // Initialize sound service (keep this until F5/Sound refactor is fully integrated)
  final soundService = SoundService();
  await soundService.initialize();

  runApp(TomadoroApp(soundService: soundService));
}

class TomadoroApp extends StatelessWidget {
  final SoundService soundService;

  const TomadoroApp({super.key, required this.soundService});

  @override
  Widget build(BuildContext context) {
    // Override the soundServiceProvider with the initialized instance
    return AccountGate(soundService: soundService, child: const _AppRoot());
  }
}

class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userNotifierProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tomadoro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
