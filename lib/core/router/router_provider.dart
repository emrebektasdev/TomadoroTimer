/// Router provider configuration.
///
/// Defines the GoRouter instance with StatefulShellRoute for persistent bottom navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/history/presentation/history_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/home/presentation/timer_screen.dart';
import '../../features/shell/presentation/shell_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/application/auth_service.dart';
import 'routes.dart';

/// Global key for the root navigator to allow overlays/dialogs without context.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the GoRouter configuration.
final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.timer,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      // If text not logged in and not heading to login, redirect to login
      if (!isLoggedIn && !isLoggingIn) return AppRoutes.login;

      // If logged in and heading to login, redirect to home
      if (isLoggedIn && isLoggingIn) return AppRoutes.timer;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // History Branch (Index 0)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: RouteNames.history,
                builder: (context, state) => const HistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: RouteNames.settings,
                    builder: (context, state) {
                      // Placeholder for Settings Screen until F2 UI refactor
                      return const Scaffold(
                        body: Center(child: Text('Settings Screen')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Timer/Home Branch (Index 1 - Default)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.timer,
                name: RouteNames.timer,
                builder: (context, state) => const TimerScreen(),
              ),
            ],
          ),

          // Shop Branch (Index 2)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shop,
                name: RouteNames.shop,
                builder: (context, state) => const ShopScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
