/// User state notifier.
///
/// Manages user state and exposes methods for user-related actions.
/// This is the bridge between UI and the domain/data layers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_settings.dart';
import '../domain/repositories/user_repository.dart';
import '../../history/domain/repositories/history_repository.dart';
import 'user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// StateNotifier for managing user state.
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;
  final HistoryRepository _historyRepository;

  UserNotifier(this._repository, this._historyRepository)
    : super(UserState.initial()) {
    // Load user data when notifier is created
    _loadUserData();
  }

  /// Loads all user data from storage.
  Future<void> _loadUserData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Load profile
    final profileResult = await _repository.getProfile();
    final settingsResult = await _repository.getSettings();
    final equippedResult = await _repository.getEquippedItems();
    final purchasedResult = await _repository.getPurchasedItemIds();

    // Combine results
    profileResult.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.displayMessage,
      ),
      (profile) {
        settingsResult.fold(
          (failure) => state = state.copyWith(
            isLoading: false,
            errorMessage: failure.displayMessage,
          ),
          (settings) {
            equippedResult.fold(
              (failure) => state = state.copyWith(
                isLoading: false,
                errorMessage: failure.displayMessage,
              ),
              (equipped) {
                purchasedResult.fold(
                  (failure) => state = state.copyWith(
                    isLoading: false,
                    errorMessage: failure.displayMessage,
                  ),
                  (purchased) {
                    state = state.copyWith(
                      profile: profile,
                      settings: settings,
                      equippedItems: equipped,
                      purchasedItemIds: purchased,
                      isLoading: false,
                      errorMessage: null,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Reloads user data (pull to refresh, etc.)
  Future<void> refresh() => _loadUserData();

  // ============ Balance Operations ============

  /// Adds tomatoes to the user's balance.
  /// Returns the new balance.
  Future<int> addTomatoes(int amount) async {
    final result = await _repository.addTomatoes(amount);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.displayMessage);
        return state.tomatoBalance;
      },
      (newBalance) {
        state = state.copyWith(
          profile: state.profile.copyWith(
            tomatoBalance: newBalance,
            totalTomatoesEarned: state.profile.totalTomatoesEarned + amount,
          ),
          errorMessage: null,
        );
        return newBalance;
      },
    );
  }

  /// Spends tomatoes (for purchases).
  /// Returns true if successful, false if insufficient balance.
  Future<bool> spendTomatoes(int amount) async {
    if (state.tomatoBalance < amount) return false;

    final newBalance = state.tomatoBalance - amount;
    final result = await _repository.saveProfile(
      state.profile.copyWith(tomatoBalance: newBalance),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.displayMessage);
        return false;
      },
      (_) {
        state = state.copyWith(
          profile: state.profile.copyWith(tomatoBalance: newBalance),
          errorMessage: null,
        );
        return true;
      },
    );
  }

  // ============ Focus Session Recording ============

  /// Records a completed focus session.
  Future<void> recordFocusSession(int minutes) async {
    final result = await _repository.recordFocusSession(minutes);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (updatedProfile) {
        state = state.copyWith(profile: updatedProfile, errorMessage: null);
        // Try to sync history to backend silently
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          _historyRepository.syncUnsyncedSessions(uid);
        }
      },
    );
  }

  // ============ Settings Operations ============

  /// Updates a single setting.
  Future<void> updateSettings(UserSettings newSettings) async {
    final result = await _repository.saveSettings(newSettings);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) => state = state.copyWith(settings: newSettings, errorMessage: null),
    );
  }

  /// Updates notifications enabled.
  Future<void> setNotificationsEnabled(bool enabled) async {
    await updateSettings(
      state.settings.copyWith(notificationsEnabled: enabled),
    );
  }

  /// Updates sound enabled.
  Future<void> setSoundEnabled(bool enabled) async {
    await updateSettings(state.settings.copyWith(soundEnabled: enabled));
  }

  /// Updates vibration enabled.
  Future<void> setVibrationEnabled(bool enabled) async {
    await updateSettings(state.settings.copyWith(vibrationEnabled: enabled));
  }

  /// Updates daily goal.
  Future<void> setDailyGoal(int minutes) async {
    await updateSettings(state.settings.copyWith(dailyGoalMinutes: minutes));
  }

  /// Updates weekly goal.
  Future<void> setWeeklyGoal(int minutes) async {
    await updateSettings(state.settings.copyWith(weeklyGoalMinutes: minutes));
  }

  /// Updates focus duration.
  Future<void> setFocusDuration(int minutes) async {
    await updateSettings(
      state.settings.copyWith(focusDurationMinutes: minutes),
    );
  }

  /// Updates short break duration.
  Future<void> setShortBreakDuration(int minutes) async {
    await updateSettings(state.settings.copyWith(shortBreakMinutes: minutes));
  }

  /// Updates long break duration.
  Future<void> setLongBreakDuration(int minutes) async {
    await updateSettings(state.settings.copyWith(longBreakMinutes: minutes));
  }

  // ============ Equipment Operations ============

  /// Equips an accessory. Pass null to unequip.
  Future<void> equipAccessory(String? accessoryId) async {
    // Verify item is purchased (if not null)
    if (accessoryId != null && !state.isItemPurchased(accessoryId)) return;

    final result = await _repository.equipAccessory(accessoryId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) => state = state.copyWith(
        equippedItems: state.equippedItems.copyWith(accessoryId: accessoryId),
        errorMessage: null,
      ),
    );
  }

  /// Equips a background. Pass null to unequip.
  Future<void> equipBackground(String? backgroundId) async {
    if (backgroundId != null && !state.isItemPurchased(backgroundId)) return;

    final result = await _repository.equipBackground(backgroundId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) => state = state.copyWith(
        equippedItems: state.equippedItems.copyWith(backgroundId: backgroundId),
        errorMessage: null,
      ),
    );
  }

  /// Equips a sound. Pass null to unequip.
  Future<void> equipSound(String? soundId) async {
    if (soundId != null && !state.isItemPurchased(soundId)) return;

    final result = await _repository.equipSound(soundId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) => state = state.copyWith(
        equippedItems: state.equippedItems.copyWith(soundId: soundId),
        errorMessage: null,
      ),
    );
  }

  // ============ Purchase Operations ============

  /// Records a purchase. Deducts balance and adds to purchased list.
  /// Returns true if successful.
  Future<bool> purchaseItem(String itemId, int price) async {
    // Check balance
    if (state.tomatoBalance < price) return false;

    // Check if already purchased
    if (state.isItemPurchased(itemId)) return false;

    // Deduct balance
    final spentSuccessfully = await spendTomatoes(price);
    if (!spentSuccessfully) return false;

    // Record purchase
    final result = await _repository.addPurchasedItem(itemId);
    return result.fold(
      (failure) {
        // Refund on failure
        addTomatoes(price);
        state = state.copyWith(errorMessage: failure.displayMessage);
        return false;
      },
      (_) {
        state = state.copyWith(
          purchasedItemIds: [...state.purchasedItemIds, itemId],
          errorMessage: null,
        );
        return true;
      },
    );
  }

  /// Clears any error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // ============ Sync Operations ============

  /// Synchronizes local data with backend cloud.
  Future<void> syncWithBackend() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Sync User Profile Data
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    final result = await _repository.syncWithBackend();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.displayMessage,
        );
      },
      (_) async {
        // Sync History Data
        if (authUid != null) {
          await _historyRepository.restoreSessionsFromBackend(authUid);
          await _historyRepository.syncUnsyncedSessions(authUid);
        }

        // Reload all data after a successful sync to update UI
        await _loadUserData();
      },
    );
  }
}
