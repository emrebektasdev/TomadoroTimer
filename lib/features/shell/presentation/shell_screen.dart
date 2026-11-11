import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../../home/presentation/timer_screen.dart';
import '../../../widgets/tomato/focus_composition.dart';

class ShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const ShellScreen({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdrop = navigationShell.currentIndex == 1
        ? ref.watch(focusBackdropProvider)?.assetPath
        : null;

    final scaffold = Scaffold(
      backgroundColor: backdrop != null ? Colors.transparent : null,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 64,
        backgroundColor: backdrop != null ? Colors.transparent : parchment,
        indicatorColor: const Color(0xffe5e9d6),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.eco_outlined), label: 'Hasat'),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            label: 'Odak',
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom_rounded),
            label: 'Gardırop',
          ),
        ],
      ),
    );
    if (backdrop == null) return scaffold;
    final media = MediaQuery.of(context);
    final spec = FocusBackdropSpec.forAsset(backdrop);
    final composition = FocusComposition.calculate(
      viewport: media.size,
      bodyHeight: media.size.height - media.viewPadding.bottom - 64,
      safeTop: media.padding.top,
      textScale: media.textScaler.scale(1),
      backdrop: spec,
    );
    return FocusCompositionScope(
      composition: composition,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FocusBackdrop(spec: spec, composition: composition),
          scaffold,
        ],
      ),
    );
  }
}
