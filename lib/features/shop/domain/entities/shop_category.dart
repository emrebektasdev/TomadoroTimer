/// Shop item category enum.
library;

/// Categories of items available in the shop.
enum ShopCategory {
  sounds,
  backgrounds,
  accessories;

  /// Display name for the category.
  String get displayName {
    switch (this) {
      case ShopCategory.sounds:
        return 'Sounds';
      case ShopCategory.backgrounds:
        return 'Backgrounds';
      case ShopCategory.accessories:
        return 'Accessories';
    }
  }

  /// Emoji icon for the category.
  String get emoji {
    switch (this) {
      case ShopCategory.sounds:
        return '🎧';
      case ShopCategory.backgrounds:
        return '🌄';
      case ShopCategory.accessories:
        return '🧢';
    }
  }
}
