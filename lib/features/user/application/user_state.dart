/// User state for the application layer.
///
/// This is the immutable state exposed to the presentation layer.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/equipped_items.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/user_settings.dart';

part 'user_state.freezed.dart';

/// Combined user state including profile, settings, and equipped items.
@freezed
class UserState with _$UserState {
  const factory UserState({
    /// User profile data (balance, stats, streak)
    required UserProfile profile,

    /// User settings/preferences
    required UserSettings settings,

    /// Currently equipped cosmetic items
    required EquippedItems equippedItems,

    /// List of purchased item IDs
    required List<String> purchasedItemIds,

    /// Whether the state is currently loading
    @Default(false) bool isLoading,

    /// Error message if something went wrong
    String? errorMessage,
  }) = _UserState;

  const UserState._();

  /// Creates the initial loading state.
  factory UserState.initial() => UserState(
    profile: UserProfile.initial(),
    settings: UserSettings.defaults(),
    equippedItems: EquippedItems.none(),
    purchasedItemIds: const [],
    isLoading: true,
  );

  /// Convenience getters for common properties
  int get tomatoBalance => profile.tomatoBalance;
  int get currentStreak => profile.currentStreak;
  int get longestStreak => profile.longestStreak;
  int get totalFocusMinutes => profile.totalFocusMinutes;
  String get formattedTotalFocusTime => profile.formattedTotalFocusTime;

  /// Equipped item IDs
  String? get equippedAccessory => equippedItems.accessoryId;
  String? get equippedBackground => equippedItems.backgroundId;
  String? get equippedSound => equippedItems.soundId;

  /// Whether an item is purchased
  bool isItemPurchased(String itemId) => purchasedItemIds.contains(itemId);

  /// Whether an item is equipped
  bool isItemEquipped(String itemId) =>
      equippedAccessory == itemId ||
      equippedBackground == itemId ||
      equippedSound == itemId;

  /// Whether there's an error
  bool get hasError => errorMessage != null;
}
