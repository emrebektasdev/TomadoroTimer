/// User state notifier.
///
/// Manages user state and exposes methods for user-related actions.
/// This is the bridge between UI and the domain/data layers.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/user_settings.dart';
import '../domain/repositories/user_repository.dart';
import '../../history/domain/repositories/history_repository.dart';
import '../domain/entities/timer_profile.dart';
import 'user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// StateNotifier for managing user state.
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;
  final HistoryRepository _historyRepository;

  UserNotifier(this._repository, this._historyRepository)
    : super(UserState.initial()) {
    // Load user data when notifier is created
    Future.microtask(() => _loadUserData());
  }

  // ============ Auth State Transitions ============

  /// Clears user session data on logout.
  Future<void> clearUserData() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.clearLocalData();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.displayMessage,
      ),
      (_) {
        state = UserState.initial();
      },
    );
  }

  /// Fetches cloud data when a new user signs in.
  Future<void> initFromCloud() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Attempt download of profile and settings overrides
    await _repository.fetchFromCloud();

    // Reload state regardless of success to reflect any fetched elements
    await _loadUserData();
  }

  /// Loads all user data from storage.
  Future<void> _loadUserData() async {
    // Load profile
    final profileResult = await _repository.getProfile();
    final settingsResult = await _repository.getSettings();
    final equippedResult = await _repository.getEquippedItems();
    final purchasedResult = await _repository.getPurchasedItemIds();

    // Check for any failures
    if (profileResult.isLeft()) {
      profileResult.fold(
        (f) => state = state.copyWith(
          isLoading: false,
          errorMessage: f.displayMessage,
        ),
        (_) {},
      );
      return;
    }
    if (settingsResult.isLeft()) {
      settingsResult.fold(
        (f) => state = state.copyWith(
          isLoading: false,
          errorMessage: f.displayMessage,
        ),
        (_) {},
      );
      return;
    }
    if (equippedResult.isLeft()) {
      equippedResult.fold(
        (f) => state = state.copyWith(
          isLoading: false,
          errorMessage: f.displayMessage,
        ),
        (_) {},
      );
      return;
    }
    if (purchasedResult.isLeft()) {
      purchasedResult.fold(
        (f) => state = state.copyWith(
          isLoading: false,
          errorMessage: f.displayMessage,
        ),
        (_) {},
      );
      return;
    }

    // All calls succeeded — extract values
    final profile = profileResult.getOrElse(() => throw Exception());
    final settings = settingsResult.getOrElse(() => throw Exception());
    final equipped = equippedResult.getOrElse(() => throw Exception());
    final purchased = purchasedResult.getOrElse(() => throw Exception());

    // Load daily sessions (async, properly awaited now)
    final sessionMapResult = await _repository.getDailyProfileSessions();
    final Map<String, int> dailySessionsMap = sessionMapResult.fold(
      (l) => {},
      (r) => r,
    );

    state = state.copyWith(
      profile: profile,
      settings: settings,
      equippedItems: equipped,
      purchasedItemIds: purchased,
      dailyProfileSessions: dailySessionsMap,
      isLoading: false,
      errorMessage: null,
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
        _syncToCloudSilently();
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
        _syncToCloudSilently();
        return true;
      },
    );
  }

  // ============ Focus Session Recording ============

  /// Records a completed focus session.
  Future<void> recordFocusSession(int minutes, {String? profileId}) async {
    // ignore: avoid_print
    print(
      '[DEBUG_SESSION] UserNotifier.recordFocusSession called: minutes=$minutes, profileId=$profileId',
    );
    final result = await _repository.recordFocusSession(
      minutes,
      profileId: profileId,
    );
    // ignore: avoid_print
    print('[DEBUG_SESSION] Repository result isRight: ${result.isRight()}');

    if (result.isLeft()) {
      result.fold(
        (failure) =>
            state = state.copyWith(errorMessage: failure.displayMessage),
        (_) {},
      );
      return;
    }

    final updatedProfile = result.getOrElse(() => state.profile);

    // Refresh the daily sessions map from local repository
    final sessionMapResult = await _repository.getDailyProfileSessions();
    final Map<String, int> dailySessionsMap = sessionMapResult.fold(
      (l) => state.dailyProfileSessions,
      (r) => r,
    );

    state = state.copyWith(
      profile: updatedProfile,
      dailyProfileSessions: dailySessionsMap,
      errorMessage: null,
    );
    // ignore: avoid_print
    print(
      '[DEBUG_SESSION] State updated. dailyProfileSessions=${state.dailyProfileSessions}',
    );

    // Try to sync history to backend silently
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _historyRepository.syncUnsyncedSessions(uid);
    }
    _syncToCloudSilently();
  }

  // ============ Settings Operations ============

  /// Updates a single setting.
  Future<void> updateSettings(UserSettings newSettings) async {
    final result = await _repository.saveSettings(newSettings);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) {
        state = state.copyWith(settings: newSettings, errorMessage: null);
        _syncToCloudSilently();
      },
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

  // ============ Timer Profile Settings ============

  /// Adds a new timer profile and optionally sets it as active.
  Future<void> addTimerProfile(
    TimerProfile profile, {
    bool makeActive = true,
  }) async {
    final currentProfiles = List<TimerProfile>.from(state.settings.profiles);
    if (!currentProfiles.any((p) => p.id == profile.id)) {
      currentProfiles.add(profile);
      await updateSettings(
        state.settings.copyWith(
          profiles: currentProfiles,
          activeProfileId: makeActive
              ? profile.id
              : state.settings.activeProfileId,
        ),
      );
    }
  }

  /// Updates an existing timer profile.
  Future<void> updateTimerProfile(TimerProfile profile) async {
    final currentProfiles = List<TimerProfile>.from(state.settings.profiles);
    final index = currentProfiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      currentProfiles[index] = profile;
      await updateSettings(state.settings.copyWith(profiles: currentProfiles));
    }
  }

  /// Deletes a custom timer profile. Default profiles cannot be deleted.
  Future<void> deleteTimerProfile(String id) async {
    if (id == 'default_pomodoro') return;

    final currentProfiles = List<TimerProfile>.from(state.settings.profiles);
    currentProfiles.removeWhere((p) => p.id == id);

    String newActiveId = state.settings.activeProfileId;
    if (newActiveId == id) {
      newActiveId = 'default_pomodoro';
    }

    await updateSettings(
      state.settings.copyWith(
        profiles: currentProfiles,
        activeProfileId: newActiveId,
      ),
    );
  }

  /// Sets the currently active timer profile.
  Future<void> setActiveTimerProfile(String id) async {
    if (state.settings.profiles.any((p) => p.id == id)) {
      await updateSettings(state.settings.copyWith(activeProfileId: id));
    }
  }

  // ============ Equipment Operations ============

  /// Equips an accessory. Pass null to unequip.
  Future<void> equipAccessory(String? accessoryId) async {
    // Verify item is purchased (if not null)
    if (accessoryId != null && !state.isItemPurchased(accessoryId)) return;

    final result = await _repository.equipAccessory(accessoryId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) {
        state = state.copyWith(
          equippedItems: state.equippedItems.copyWith(accessoryId: accessoryId),
          errorMessage: null,
        );
        _syncToCloudSilently();
      },
    );
  }

  /// Equips a background. Pass null to unequip.
  Future<void> equipBackground(String? backgroundId) async {
    if (backgroundId != null && !state.isItemPurchased(backgroundId)) return;

    final result = await _repository.equipBackground(backgroundId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) {
        state = state.copyWith(
          equippedItems: state.equippedItems.copyWith(
            backgroundId: backgroundId,
          ),
          errorMessage: null,
        );
        _syncToCloudSilently();
      },
    );
  }

  /// Equips a sound. Pass null to unequip.
  Future<void> equipSound(String? soundId) async {
    if (soundId != null && !state.isItemPurchased(soundId)) return;

    final result = await _repository.equipSound(soundId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.displayMessage),
      (_) {
        state = state.copyWith(
          equippedItems: state.equippedItems.copyWith(soundId: soundId),
          errorMessage: null,
        );
        _syncToCloudSilently();
      },
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
        _syncToCloudSilently();
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

  /// Pushes local data to the backend silently without showing loading indicators.
  void _syncToCloudSilently() {
    final authUid = FirebaseAuth.instance.currentUser?.uid;
    if (authUid != null) {
      _repository.syncWithBackend();
    }
  }
}
