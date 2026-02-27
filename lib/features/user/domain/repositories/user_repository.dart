/// User repository interface.
///
/// Defines the contract for user data persistence.
/// Implementation details are in the data layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/equipped_items.dart';
import '../entities/user_profile.dart';
import '../entities/user_settings.dart';

/// Repository contract for user-related data operations.
abstract class UserRepository {
  // ============ Profile Operations ============

  /// Loads the user profile from storage.
  Future<Either<Failure, UserProfile>> getProfile();

  /// Saves the user profile to storage.
  Future<Either<Failure, Unit>> saveProfile(UserProfile profile);

  /// Adds tomatoes to the user's balance.
  ///
  /// Returns the new balance after addition.
  Future<Either<Failure, int>> addTomatoes(int amount);

  /// Records focus minutes and updates streak.
  ///
  /// This should be called when a focus session completes.
  Future<Either<Failure, UserProfile>> recordFocusSession(int minutes);

  // ============ Settings Operations ============

  /// Loads user settings from storage.
  Future<Either<Failure, UserSettings>> getSettings();

  /// Saves user settings to storage.
  Future<Either<Failure, Unit>> saveSettings(UserSettings settings);

  // ============ Equipped Items Operations ============

  /// Gets currently equipped items.
  Future<Either<Failure, EquippedItems>> getEquippedItems();

  /// Saves equipped items.
  Future<Either<Failure, Unit>> saveEquippedItems(EquippedItems items);

  /// Equips an accessory by ID. Pass null to unequip.
  Future<Either<Failure, Unit>> equipAccessory(String? accessoryId);

  /// Equips a background by ID. Pass null to unequip.
  Future<Either<Failure, Unit>> equipBackground(String? backgroundId);

  /// Equips a sound by ID. Pass null to unequip.
  Future<Either<Failure, Unit>> equipSound(String? soundId);

  // ============ Purchase Tracking ============

  /// Gets the list of purchased item IDs.
  Future<Either<Failure, List<String>>> getPurchasedItemIds();

  /// Adds an item to the purchased list.
  Future<Either<Failure, Unit>> addPurchasedItem(String itemId);

  /// Checks if an item is already purchased.
  Future<Either<Failure, bool>> isItemPurchased(String itemId);

  // ============ Sync Operations ============

  /// Synchronizes local data with the backend cloud.
  Future<Either<Failure, Unit>> syncWithBackend();
}
