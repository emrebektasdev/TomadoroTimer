/// Core-level Riverpod providers.
///
/// These providers are shared across all features and provide
/// access to infrastructure-level dependencies.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/storage_keys.dart';

/// Provides access to Hive boxes.
final hiveProvider = Provider<HiveInterface>((ref) => Hive);

/// Provides user profile Hive box.
final userProfileBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.userProfile);
});

/// Provides app config Hive box.
final appConfigBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.appConfig);
});

/// Provides shop data Hive box.
final shopDataBoxProvider = Provider<Box>((ref) {
  return Hive.box(HiveBoxes.shopData);
});

/// Provides the SoundService instance (overridden in main.dart).
final soundServiceProvider = Provider<dynamic>((ref) {
  throw UnimplementedError('SoundService must be overridden in ProviderScope');
});
