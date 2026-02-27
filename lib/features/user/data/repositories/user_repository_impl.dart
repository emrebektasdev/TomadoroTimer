/// User repository implementation.
///
/// Implements the UserRepository interface using Hive for persistence.
/// Converts exceptions to Failures for proper error handling.
library;

import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../domain/entities/equipped_items.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

/// Implementation of [UserRepository] using Hive for local storage.
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  // ============ Profile Operations ============

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = UserProfile(
        tomatoBalance: _localDataSource.getTomatoBalance(),
        totalTomatoesEarned: _localDataSource.getTotalTomatoesEarned(),
        totalFocusMinutes: _localDataSource.getTotalFocusMinutes(),
        currentStreak: _localDataSource.getCurrentStreak(),
        longestStreak: _localDataSource.getLongestStreak(),
        lastActiveDate: _localDataSource.getLastActiveDate(),
      );
      return Right(profile);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to load profile', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveProfile(UserProfile profile) async {
    try {
      await _localDataSource.setTomatoBalance(profile.tomatoBalance);
      await _localDataSource.setTotalTomatoesEarned(
        profile.totalTomatoesEarned,
      );
      await _localDataSource.setTotalFocusMinutes(profile.totalFocusMinutes);
      await _localDataSource.setCurrentStreak(profile.currentStreak);
      await _localDataSource.setLongestStreak(profile.longestStreak);
      if (profile.lastActiveDate != null) {
        await _localDataSource.setLastActiveDate(profile.lastActiveDate!);
      }
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to save profile', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, int>> addTomatoes(int amount) async {
    try {
      final currentBalance = _localDataSource.getTomatoBalance();
      final currentTotal = _localDataSource.getTotalTomatoesEarned();

      final newBalance = currentBalance + amount;
      final newTotal = currentTotal + amount;

      await _localDataSource.setTomatoBalance(newBalance);
      await _localDataSource.setTotalTomatoesEarned(newTotal);

      return Right(newBalance);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to add tomatoes', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, UserProfile>> recordFocusSession(int minutes) async {
    try {
      // Update total focus minutes
      final currentMinutes = _localDataSource.getTotalFocusMinutes();
      await _localDataSource.setTotalFocusMinutes(currentMinutes + minutes);

      // Update streak
      await _updateStreak();

      // Return updated profile
      return getProfile();
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to record session',
          originalError: e,
        ),
      );
    }
  }

  /// Updates the user's streak based on activity.
  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = now.dateOnly;
    final lastActiveDate = _localDataSource.getLastActiveDate();

    int currentStreak = _localDataSource.getCurrentStreak();
    int longestStreak = _localDataSource.getLongestStreak();

    if (lastActiveDate == null) {
      // First time using the app
      currentStreak = 1;
    } else {
      final lastActive = lastActiveDate.dateOnly;
      final difference = today.difference(lastActive).inDays;

      if (difference == 0) {
        // Same day, streak unchanged
      } else if (difference == 1) {
        // Consecutive day, increment streak
        currentStreak++;
      } else {
        // Streak broken
        currentStreak = 1;
      }
    }

    // Update longest streak if current is higher
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
      await _localDataSource.setLongestStreak(longestStreak);
    }

    await _localDataSource.setCurrentStreak(currentStreak);
    await _localDataSource.setLastActiveDate(today);
  }

  // ============ Settings Operations ============

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final settings = UserSettings(
        notificationsEnabled: _localDataSource.getBoolSetting(
          SettingsKeys.notificationsEnabled,
          defaultValue: true,
        ),
        soundEnabled: _localDataSource.getBoolSetting(
          SettingsKeys.soundEnabled,
          defaultValue: true,
        ),
        vibrationEnabled: _localDataSource.getBoolSetting(
          SettingsKeys.vibrationEnabled,
          defaultValue: true,
        ),
        dailyGoalMinutes: _localDataSource.getIntSetting(
          SettingsKeys.dailyGoalMinutes,
          defaultValue: 120,
        ),
        weeklyGoalMinutes: _localDataSource.getIntSetting(
          SettingsKeys.weeklyGoalMinutes,
          defaultValue: 600,
        ),
        focusDurationMinutes: _localDataSource.getIntSetting(
          SettingsKeys.focusDuration,
          defaultValue: 25,
        ),
        shortBreakMinutes: _localDataSource.getIntSetting(
          SettingsKeys.shortBreakDuration,
          defaultValue: 5,
        ),
        longBreakMinutes: _localDataSource.getIntSetting(
          SettingsKeys.longBreakDuration,
          defaultValue: 15,
        ),
      );
      return Right(settings);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load settings',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(UserSettings settings) async {
    try {
      await _localDataSource.setBoolSetting(
        SettingsKeys.notificationsEnabled,
        settings.notificationsEnabled,
      );
      await _localDataSource.setBoolSetting(
        SettingsKeys.soundEnabled,
        settings.soundEnabled,
      );
      await _localDataSource.setBoolSetting(
        SettingsKeys.vibrationEnabled,
        settings.vibrationEnabled,
      );
      await _localDataSource.setIntSetting(
        SettingsKeys.dailyGoalMinutes,
        settings.dailyGoalMinutes,
      );
      await _localDataSource.setIntSetting(
        SettingsKeys.weeklyGoalMinutes,
        settings.weeklyGoalMinutes,
      );
      await _localDataSource.setIntSetting(
        SettingsKeys.focusDuration,
        settings.focusDurationMinutes,
      );
      await _localDataSource.setIntSetting(
        SettingsKeys.shortBreakDuration,
        settings.shortBreakMinutes,
      );
      await _localDataSource.setIntSetting(
        SettingsKeys.longBreakDuration,
        settings.longBreakMinutes,
      );
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to save settings',
          originalError: e,
        ),
      );
    }
  }

  // ============ Equipped Items Operations ============

  @override
  Future<Either<Failure, EquippedItems>> getEquippedItems() async {
    try {
      final items = EquippedItems(
        accessoryId: _localDataSource.getEquippedAccessory(),
        backgroundId: _localDataSource.getEquippedBackground(),
        soundId: _localDataSource.getEquippedSound(),
      );
      return Right(items);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load equipped items',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveEquippedItems(EquippedItems items) async {
    try {
      await _localDataSource.setEquippedAccessory(items.accessoryId);
      await _localDataSource.setEquippedBackground(items.backgroundId);
      await _localDataSource.setEquippedSound(items.soundId);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to save equipped items',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> equipAccessory(String? accessoryId) async {
    try {
      await _localDataSource.setEquippedAccessory(accessoryId);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to equip accessory',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> equipBackground(String? backgroundId) async {
    try {
      await _localDataSource.setEquippedBackground(backgroundId);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to equip background',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> equipSound(String? soundId) async {
    try {
      await _localDataSource.setEquippedSound(soundId);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to equip sound', originalError: e),
      );
    }
  }

  // ============ Purchase Tracking ============

  @override
  Future<Either<Failure, List<String>>> getPurchasedItemIds() async {
    try {
      final ids = _localDataSource.getPurchasedItemIds();
      return Right(ids);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load purchases',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addPurchasedItem(String itemId) async {
    try {
      await _localDataSource.addPurchasedItem(itemId);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to record purchase',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isItemPurchased(String itemId) async {
    try {
      final isPurchased = _localDataSource.isItemPurchased(itemId);
      return Right(isPurchased);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to check purchase',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> syncWithBackend() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return const Right(unit); // Wait until user is logged in

      final profile = await getProfile();
      final equipped = await getEquippedItems();
      final purchases = await getPurchasedItemIds();

      if (profile.isLeft() || equipped.isLeft() || purchases.isLeft()) {
        return Left(
          Failure.unexpected(message: 'Failed to read local data for sync'),
        );
      }

      final p = profile.getOrElse(() => throw Exception());
      final e = equipped.getOrElse(() => throw Exception());
      final purchased = purchases.getOrElse(() => throw Exception());

      final localData = {
        'tomatoBalance': p.tomatoBalance,
        'currentStreak': p.currentStreak,
        'totalFocusMinutes': p.totalFocusMinutes,
        'equippedBackground': e.backgroundId,
        'equippedAccessory': e.accessoryId,
        'equippedSound': e.soundId,
        'purchasedItems': purchased,
        'lastActiveDate': p.lastActiveDate?.toIso8601String(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);

      // Perform a merge so we don't overwrite if the backend has newer fields
      // For a robust sync, you might want to read first, compare, then write.
      // Here we will do a basic read and merge.
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;

        // Simple logic: If local data seems newer or we just prefer local state:
        // Updating remote with local changes.
        await userDocRef.set(localData, SetOptions(merge: true));

        // Similarly read fields from remote to local
        await _localDataSource.setTomatoBalance(
          data['tomatoBalance'] ?? p.tomatoBalance,
        );
        await _localDataSource.setCurrentStreak(
          data['currentStreak'] ?? p.currentStreak,
        );
        await _localDataSource.setTotalFocusMinutes(
          data['totalFocusMinutes'] ?? p.totalFocusMinutes,
        );

        if (data['equippedBackground'] != null)
          await _localDataSource.setEquippedBackground(
            data['equippedBackground'],
          );
        if (data['equippedAccessory'] != null)
          await _localDataSource.setEquippedAccessory(
            data['equippedAccessory'],
          );
        if (data['equippedSound'] != null)
          await _localDataSource.setEquippedSound(data['equippedSound']);

        if (data['lastActiveDate'] != null) {
          await _localDataSource.setLastActiveDate(
            DateTime.parse(data['lastActiveDate']),
          );
        }

        final items = List<String>.from(data['purchasedItems'] ?? []);
        for (final item in items) {
          await _localDataSource.addPurchasedItem(item);
        }
      } else {
        // Doc doesn't exist, create it from local data
        await userDocRef.set(localData);
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Network error during sync',
          originalError: e,
        ),
      );
    }
  }
}
