/// Shop state notifier.
///
/// Manages shop state and item selection.
/// Note: Purchase and equip operations are delegated to UserNotifier.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/shop_category.dart';
import '../domain/repositories/shop_repository.dart';
import 'shop_state.dart';

/// StateNotifier for managing shop state.
class ShopNotifier extends StateNotifier<ShopState> {
  final ShopRepository _repository;

  ShopNotifier(this._repository) : super(const ShopState()) {
    _loadItems();
  }

  /// Loads all shop items.
  Future<void> _loadItems() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.getAllItems();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.displayMessage,
      ),
      (items) => state = state.copyWith(
        allItems: items,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  /// Selects a category.
  void selectCategory(ShopCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      searchQuery: '', // Clear search when changing category
    );
  }

  /// Sets search query.
  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Clears search.
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  /// Refreshes items.
  Future<void> refresh() => _loadItems();

  /// Clears error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
