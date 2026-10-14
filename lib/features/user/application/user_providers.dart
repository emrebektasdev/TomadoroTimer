/// User feature Riverpod providers.
///
/// This file defines all the providers for the user feature,
/// following dependency injection principles.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/account_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../data/datasources/user_local_datasource.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../../history/application/history_providers.dart';
import 'user_notifier.dart';
import 'user_state.dart';

// ============ Data Layer Providers ============

/// Provides the user Hive box.
final userBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.userProfile);
});

/// Provides the user local data source.
final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final box = ref.watch(userBoxProvider);
  return UserLocalDataSource(box);
});

/// Provides the user repository implementation.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepositoryImpl(
    dataSource,
    accountId: ref.watch(accountIdProvider),
  );
});

// ============ Application Layer Providers ============

/// Main user state notifier provider.
///
/// This is the primary way to access user state in the app.
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((
  ref,
) {
  final repository = ref.watch(userRepositoryProvider);
  final historyRepository = ref.watch(historyRepositoryProvider);
  return UserNotifier(repository, historyRepository);
});

// ============ Selector Providers (for granular rebuilds) ============

/// Provides just the tomato balance (for efficient rebuilds).
final tomatoBalanceProvider = Provider<int>((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.tomatoBalance));
});

/// Provides the current streak.
final currentStreakProvider = Provider<int>((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.currentStreak));
});

/// Provides the equipped background ID.
final equippedBackgroundProvider = Provider<String?>((ref) {
  return ref.watch(
    userNotifierProvider.select((state) => state.equippedBackground),
  );
});

/// Provides the equipped accessory ID.
final equippedAccessoryProvider = Provider<String?>((ref) {
  return ref.watch(
    userNotifierProvider.select((state) => state.equippedAccessory),
  );
});

/// Provides the equipped sound ID.
final equippedSoundProvider = Provider<String?>((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.equippedSound));
});

/// Provides user settings.
final userSettingsProvider = Provider((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.settings));
});

/// Provides loading state.
final userLoadingProvider = Provider<bool>((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.isLoading));
});

/// Provides error state.
final userErrorProvider = Provider<String?>((ref) {
  return ref.watch(userNotifierProvider.select((state) => state.errorMessage));
});

/// Provides total focus minutes.
final totalFocusMinutesProvider = Provider<int>((ref) {
  return ref.watch(
    userNotifierProvider.select((state) => state.totalFocusMinutes),
  );
});

/// Provides formatted total focus time.
final formattedTotalFocusTimeProvider = Provider<String>((ref) {
  return ref.watch(
    userNotifierProvider.select((state) => state.formattedTotalFocusTime),
  );
});

/// Provider to check if a specific item is purchased.
final isItemPurchasedProvider = Provider.family<bool, String>((ref, itemId) {
  return ref.watch(
    userNotifierProvider.select((state) => state.isItemPurchased(itemId)),
  );
});

/// Provider to check if a specific item is equipped.
final isItemEquippedProvider = Provider.family<bool, String>((ref, itemId) {
  return ref.watch(
    userNotifierProvider.select((state) => state.isItemEquipped(itemId)),
  );
});
