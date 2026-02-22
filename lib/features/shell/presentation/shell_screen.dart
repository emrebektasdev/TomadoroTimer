/// Main application shell using GoRouter.
///
/// Adapts the legacy MainShell design to work with StatefulNavigationShell.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

/// Shell screen with floating bottom navigation bar.
class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          navigationShell,

          // Floating bottom navigation bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _FloatingNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom floating bottom navigation bar
class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left spacer for balance alignment
          const SizedBox(width: 8),

          // History/Progress button (Index 0)
          Expanded(
            child: Center(
              child: _NavBarItem(
                icon: Icons.insert_chart_outlined_rounded,
                label: 'Progress',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
          ),

          // Home/Timer button (Index 1 - Center)
          _CenterNavButton(
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),

          // Shop button (Index 2)
          Expanded(
            child: Center(
              child: _NavBarItem(
                icon: Icons.storefront_outlined,
                label: 'Shop',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ),

          // Right spacer for balance alignment
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Regular navigation bar item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  size: 26,
                  color: isSelected
                      ? AppColors.tomatoRed
                      : AppColors.navBarIconInactive,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.tomatoRed
                      : AppColors.navBarIconInactive,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Center navigation button (Tomato/Home)
class _CenterNavButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterNavButton({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [AppColors.tomatoRed, AppColors.tomatoRedDark]
                : [
                    AppColors.tomatoRedLight.withAlpha(150),
                    AppColors.tomatoRedLight.withAlpha(100),
                  ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.tomatoRed.withAlpha(isSelected ? 80 : 40),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Text('🍅', style: TextStyle(fontSize: 28)),
          ),
        ),
      ),
    );
  }
}
