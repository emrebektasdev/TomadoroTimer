/// Shop feature Riverpod providers.
///
/// Providers for the shop feature with dependency injection.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/shop_repository_impl.dart';
import '../domain/entities/shop_category.dart';
import '../domain/entities/shop_item.dart';
import '../domain/repositories/shop_repository.dart';
import 'shop_notifier.dart';
import 'shop_state.dart';

// ============ Data Layer Providers ============

/// Provides the shop repository.
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl();
});

// ============ Application Layer Providers ============

/// Main shop state notifier provider.
final shopNotifierProvider = StateNotifierProvider<ShopNotifier, ShopState>((
  ref,
) {
  final repository = ref.watch(shopRepositoryProvider);
  return ShopNotifier(repository);
});

// ============ Selector Providers ============

/// Provides the selected category.
final selectedCategoryProvider = Provider<ShopCategory>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.selectedCategory));
});

/// Provides items for the current category.
final categoryItemsProvider = Provider<List<ShopItem>>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.categoryItems));
});

/// Provides all shop items.
final allShopItemsProvider = Provider<List<ShopItem>>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.allItems));
});

/// Provides sound items.
final soundItemsProvider = Provider<List<ShopItem>>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.soundItems));
});

/// Provides background items.
final backgroundItemsProvider = Provider<List<ShopItem>>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.backgroundItems));
});

/// Provides accessory items.
final accessoryItemsProvider = Provider<List<ShopItem>>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.accessoryItems));
});

/// Provides the search query.
final shopSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.searchQuery));
});

/// Provides loading state.
final shopLoadingProvider = Provider<bool>((ref) {
  return ref.watch(shopNotifierProvider.select((s) => s.isLoading));
});

/// Gets a specific shop item by ID.
final shopItemByIdProvider = Provider.family<ShopItem?, String>((ref, id) {
  final items = ref.watch(allShopItemsProvider);
  try {
    return items.firstWhere((item) => item.id == id);
  } catch (_) {
    return null;
  }
});
