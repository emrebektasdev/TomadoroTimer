/// Shop state for the application layer.
///
/// Immutable state exposed to the presentation layer.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/shop_category.dart';
import '../domain/entities/shop_item.dart';

part 'shop_state.freezed.dart';

/// Shop state with items and selection.
@freezed
class ShopState with _$ShopState {
  const factory ShopState({
    /// All available shop items
    @Default([]) List<ShopItem> allItems,

    /// Currently selected category
    @Default(ShopCategory.sounds) ShopCategory selectedCategory,

    /// Search query (if any)
    @Default('') String searchQuery,

    /// Whether items are loading
    @Default(false) bool isLoading,

    /// Error message if something went wrong
    String? errorMessage,
  }) = _ShopState;

  const ShopState._();

  /// Gets items for the currently selected category.
  List<ShopItem> get categoryItems {
    if (searchQuery.isNotEmpty) {
      return filteredItems;
    }
    return allItems.where((item) => item.category == selectedCategory).toList();
  }

  /// Gets items filtered by search query.
  List<ShopItem> get filteredItems {
    if (searchQuery.isEmpty) return allItems;
    final query = searchQuery.toLowerCase();
    return allItems.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
    }).toList();
  }

  /// Gets sound items.
  List<ShopItem> get soundItems =>
      allItems.where((item) => item.isSound).toList();

  /// Gets background items.
  List<ShopItem> get backgroundItems =>
      allItems.where((item) => item.isBackground).toList();

  /// Gets accessory items.
  List<ShopItem> get accessoryItems =>
      allItems.where((item) => item.isAccessory).toList();

  /// Whether there's an error
  bool get hasError => errorMessage != null;

  /// Whether search is active
  bool get isSearching => searchQuery.isNotEmpty;
}
