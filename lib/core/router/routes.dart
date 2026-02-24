/// Route definitions for go_router.
///
/// All route paths are defined here to ensure type-safety
/// and prevent path string duplication.
library;

/// Application route paths.
abstract final class AppRoutes {
  /// Login Screen
  static const String login = '/login';

  /// Home/Timer screen (main screen)
  static const String timer = '/';

  /// History/Statistics screen
  static const String history = '/history';

  /// Shop screen
  static const String shop = '/shop';

  /// Settings screen (sub-route of history)
  static const String settings = '/history/settings';
}

/// Route names for navigation.
abstract final class RouteNames {
  static const String login = 'login';
  static const String timer = 'timer';
  static const String history = 'history';
  static const String shop = 'shop';
  static const String settings = 'settings';
}
