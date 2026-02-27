/// Storage keys for Hive boxes and SharedPreferences.
///
/// Centralizing all storage keys prevents typos and makes
/// it easy to see all persisted data at a glance.
library;

/// Hive box names
abstract final class HiveBoxes {
  static const String userProfile = 'user_profile';
  static const String focusSessions = 'focus_sessions';
  static const String dailyStats = 'daily_stats';
  static const String shopData = 'shop_data';
  static const String appConfig = 'app_config';
  static const String timerState = 'timer_state';
}

/// Keys within user profile box
abstract final class UserProfileKeys {
  static const String tomatoBalance = 'tomato_balance';
  static const String totalTomatoesEarned = 'total_tomatoes_earned';
  static const String totalFocusMinutes = 'total_focus_minutes';
  static const String currentStreak = 'current_streak';
  static const String longestStreak = 'longest_streak';
  static const String lastActiveDate = 'last_active_date';
  static const String purchasedItemIds = 'purchased_item_ids';
  static const String equippedAccessory = 'equipped_accessory';
  static const String equippedBackground = 'equipped_background';
  static const String equippedSound = 'equipped_sound';
  static const String dailyProfileSessions = 'daily_profile_sessions';
}

/// Keys for user settings
abstract final class SettingsKeys {
  static const String notificationsEnabled = 'notifications_enabled';
  static const String soundEnabled = 'sound_enabled';
  static const String vibrationEnabled = 'vibration_enabled';
  static const String dailyGoalMinutes = 'daily_goal_minutes';
  static const String weeklyGoalMinutes = 'weekly_goal_minutes';
  static const String timerProfiles = 'timer_profiles';
  static const String activeTimerProfile = 'active_timer_profile';
}

/// Migration tracking keys
abstract final class MigrationKeys {
  static const String sharedPreferencesMigrated = 'sp_migrated';
  static const String migrationVersion = 'migration_version';
}
