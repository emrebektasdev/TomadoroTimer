import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/tomato/cozy_scene.dart';
import '../../home/presentation/timer_screen.dart';

class ShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const ShellScreen({super.key, required this.navigationShell});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdrop = navigationShell.currentIndex == 1
        ? ref.watch(focusBackdropProvider)?.assetPath
        : null;

    return DecoratedBox(
      decoration: backdrop != null
          ? BoxDecoration(
              color: parchment,
              image: DecorationImage(
                image: AssetImage(backdrop),
                fit: BoxFit.cover,
              ),
            )
          : const BoxDecoration(),
      child: Scaffold(
        backgroundColor: backdrop != null ? Colors.transparent : null,
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          height: 64,
          backgroundColor: backdrop != null ? Colors.transparent : parchment,
          indicatorColor: const Color(0xffe5e9d6),
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (i) => navigationShell.goBranch(i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.eco_outlined),
              label: 'Hasat',
            ),
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
      ),
    );
  }
}
