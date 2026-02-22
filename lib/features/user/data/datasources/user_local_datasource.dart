/// User local data source.
///
/// Handles direct interaction with Hive for user data persistence.
/// Throws exceptions that are caught by the repository.
library;

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';

/// Local data source for user-related data using Hive.
class UserLocalDataSource {
  final Box _userBox;

  UserLocalDataSource(this._userBox);

  // ============ Profile Data ============

  /// Gets the tomato balance.
  int getTomatoBalance() {
    return _userBox.get(UserProfileKeys.tomatoBalance, defaultValue: 0) as int;
  }

  /// Sets the tomato balance.
  Future<void> setTomatoBalance(int balance) async {
    await _userBox.put(UserProfileKeys.tomatoBalance, balance);
  }

  /// Gets total tomatoes earned.
  int getTotalTomatoesEarned() {
    return _userBox.get(UserProfileKeys.totalTomatoesEarned, defaultValue: 0)
        as int;
  }

  /// Sets total tomatoes earned.
  Future<void> setTotalTomatoesEarned(int total) async {
    await _userBox.put(UserProfileKeys.totalTomatoesEarned, total);
  }

  /// Gets total focus minutes.
  int getTotalFocusMinutes() {
    return _userBox.get(UserProfileKeys.totalFocusMinutes, defaultValue: 0)
        as int;
  }

  /// Sets total focus minutes.
  Future<void> setTotalFocusMinutes(int minutes) async {
    await _userBox.put(UserProfileKeys.totalFocusMinutes, minutes);
  }

  /// Gets current streak.
  int getCurrentStreak() {
    return _userBox.get(UserProfileKeys.currentStreak, defaultValue: 0) as int;
  }

  /// Sets current streak.
  Future<void> setCurrentStreak(int streak) async {
    await _userBox.put(UserProfileKeys.currentStreak, streak);
  }

  /// Gets longest streak.
  int getLongestStreak() {
    return _userBox.get(UserProfileKeys.longestStreak, defaultValue: 0) as int;
  }

  /// Sets longest streak.
  Future<void> setLongestStreak(int streak) async {
    await _userBox.put(UserProfileKeys.longestStreak, streak);
  }

  /// Gets last active date.
  DateTime? getLastActiveDate() {
    final dateStr = _userBox.get(UserProfileKeys.lastActiveDate) as String?;
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// Sets last active date.
  Future<void> setLastActiveDate(DateTime date) async {
    await _userBox.put(UserProfileKeys.lastActiveDate, date.toIso8601String());
  }

  // ============ Settings Data ============

  /// Gets a boolean setting with a default value.
  bool getBoolSetting(String key, {bool defaultValue = true}) {
    return _userBox.get(key, defaultValue: defaultValue) as bool;
  }

  /// Sets a boolean setting.
  Future<void> setBoolSetting(String key, bool value) async {
    await _userBox.put(key, value);
  }

  /// Gets an integer setting with a default value.
  int getIntSetting(String key, {required int defaultValue}) {
    return _userBox.get(key, defaultValue: defaultValue) as int;
  }

  /// Sets an integer setting.
  Future<void> setIntSetting(String key, int value) async {
    await _userBox.put(key, value);
  }

  // ============ Equipped Items ============

  /// Gets equipped accessory ID.
  String? getEquippedAccessory() {
    return _userBox.get(UserProfileKeys.equippedAccessory) as String?;
  }

  /// Sets equipped accessory ID.
  Future<void> setEquippedAccessory(String? id) async {
    if (id == null) {
      await _userBox.delete(UserProfileKeys.equippedAccessory);
    } else {
      await _userBox.put(UserProfileKeys.equippedAccessory, id);
    }
  }

  /// Gets equipped background ID.
  String? getEquippedBackground() {
    return _userBox.get(UserProfileKeys.equippedBackground) as String?;
  }

  /// Sets equipped background ID.
  Future<void> setEquippedBackground(String? id) async {
    if (id == null) {
      await _userBox.delete(UserProfileKeys.equippedBackground);
    } else {
      await _userBox.put(UserProfileKeys.equippedBackground, id);
    }
  }

  /// Gets equipped sound ID.
  String? getEquippedSound() {
    return _userBox.get(UserProfileKeys.equippedSound) as String?;
  }

  /// Sets equipped sound ID.
  Future<void> setEquippedSound(String? id) async {
    if (id == null) {
      await _userBox.delete(UserProfileKeys.equippedSound);
    } else {
      await _userBox.put(UserProfileKeys.equippedSound, id);
    }
  }

  // ============ Purchased Items ============

  /// Gets list of purchased item IDs.
  List<String> getPurchasedItemIds() {
    final list = _userBox.get(UserProfileKeys.purchasedItemIds);
    if (list == null) return [];
    return List<String>.from(list as List);
  }

  /// Adds an item to the purchased list.
  Future<void> addPurchasedItem(String itemId) async {
    final current = getPurchasedItemIds();
    if (!current.contains(itemId)) {
      current.add(itemId);
      await _userBox.put(UserProfileKeys.purchasedItemIds, current);
    }
  }

  /// Checks if an item is purchased.
  bool isItemPurchased(String itemId) {
    return getPurchasedItemIds().contains(itemId);
  }

  // ============ Migration Support ============

  /// Migrates data from SharedPreferences (one-time migration).
  Future<void> migrateFromSharedPreferences(Map<String, dynamic> data) async {
    try {
      // Check if already migrated
      final migrated =
          _userBox.get(
                MigrationKeys.sharedPreferencesMigrated,
                defaultValue: false,
              )
              as bool;
      if (migrated) return;

      // Migrate each field if present
      if (data.containsKey('tomatoBalance')) {
        await setTomatoBalance(data['tomatoBalance'] as int);
      }
      if (data.containsKey('totalTomatoesEarned')) {
        await setTotalTomatoesEarned(data['totalTomatoesEarned'] as int);
      }
      if (data.containsKey('totalFocusMinutes')) {
        await setTotalFocusMinutes(data['totalFocusMinutes'] as int);
      }
      if (data.containsKey('currentStreak')) {
        await setCurrentStreak(data['currentStreak'] as int);
      }
      if (data.containsKey('longestStreak')) {
        await setLongestStreak(data['longestStreak'] as int);
      }
      if (data.containsKey('lastActiveDate')) {
        await _userBox.put(
          UserProfileKeys.lastActiveDate,
          data['lastActiveDate'],
        );
      }
      if (data.containsKey('purchasedItemIds')) {
        await _userBox.put(
          UserProfileKeys.purchasedItemIds,
          data['purchasedItemIds'],
        );
      }
      if (data.containsKey('equippedAccessory')) {
        await setEquippedAccessory(data['equippedAccessory'] as String?);
      }
      if (data.containsKey('equippedBackground')) {
        await setEquippedBackground(data['equippedBackground'] as String?);
      }
      if (data.containsKey('equippedSound')) {
        await setEquippedSound(data['equippedSound'] as String?);
      }

      // Mark as migrated
      await _userBox.put(MigrationKeys.sharedPreferencesMigrated, true);
    } catch (e, stackTrace) {
      throw CacheException(
        'Failed to migrate user data from SharedPreferences',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
