/// Shop item categories
enum ShopCategory {
  sounds,
  backgrounds,
  accessories,
}

/// Extension for shop category properties
extension ShopCategoryExtension on ShopCategory {
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

/// Represents an item in the shop
class ShopItem {
  final String id;
  final String name;
  final String description;
  final ShopCategory category;
  final int price;
  final String? assetPath;
  final bool isPurchased;
  final bool isEquipped;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.assetPath,
    this.isPurchased = false,
    this.isEquipped = false,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    ShopCategory? category,
    int? price,
    String? assetPath,
    bool? isPurchased,
    bool? isEquipped,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      assetPath: assetPath ?? this.assetPath,
      isPurchased: isPurchased ?? this.isPurchased,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }
}

/// Default shop items
class DefaultShopItems {
  static const List<ShopItem> sounds = [
    ShopItem(
      id: 'sound_rain',
      name: 'Rain Sound',
      description: 'Relaxing rain ambience for deep focus',
      category: ShopCategory.sounds,
      price: 10,
      assetPath: 'assets/sounds/rain.mp3',
    ),
    ShopItem(
      id: 'sound_forest',
      name: 'Forest Sound',
      description: 'Peaceful forest with birds chirping',
      category: ShopCategory.sounds,
      price: 15,
      assetPath: 'assets/sounds/forest.mp3',
    ),
    ShopItem(
      id: 'sound_ocean',
      name: 'Ocean Sound',
      description: 'Calm ocean waves for serenity',
      category: ShopCategory.sounds,
      price: 15,
      assetPath: 'assets/sounds/ocean.mp3',
    ),
    ShopItem(
      id: 'sound_cafe',
      name: 'Café Ambience',
      description: 'Coffee shop background noise',
      category: ShopCategory.sounds,
      price: 20,
      assetPath: 'assets/sounds/cafe.mp3',
    ),
    ShopItem(
      id: 'sound_fireplace',
      name: 'Fireplace',
      description: 'Cozy crackling fireplace sounds',
      category: ShopCategory.sounds,
      price: 20,
      assetPath: 'assets/sounds/fireplace.mp3',
    ),
  ];

  static const List<ShopItem> backgrounds = [
    ShopItem(
      id: 'bg_sunset',
      name: 'Sunset Theme',
      description: 'Warm sunset gradient background',
      category: ShopCategory.backgrounds,
      price: 25,
      assetPath: 'sunset',
    ),
    ShopItem(
      id: 'bg_night',
      name: 'Night Theme',
      description: 'Calm night sky gradient',
      category: ShopCategory.backgrounds,
      price: 25,
      assetPath: 'night',
    ),
    ShopItem(
      id: 'bg_forest',
      name: 'Forest Theme',
      description: 'Peaceful green forest vibes',
      category: ShopCategory.backgrounds,
      price: 30,
      assetPath: 'forest',
    ),
    ShopItem(
      id: 'bg_ocean',
      name: 'Ocean Theme',
      description: 'Serene blue ocean tones',
      category: ShopCategory.backgrounds,
      price: 30,
      assetPath: 'ocean',
    ),
  ];

  static const List<ShopItem> accessories = [
    ShopItem(
      id: 'acc_sunglasses',
      name: 'Sunglasses',
      description: 'Cool sunglasses for your tomato',
      category: ShopCategory.accessories,
      price: 30,
      assetPath: 'sunglasses',
    ),
    ShopItem(
      id: 'acc_eyepatch',
      name: 'Pirate Eye Patch',
      description: 'Arrr! A pirate eye patch',
      category: ShopCategory.accessories,
      price: 35,
      assetPath: 'eyepatch',
    ),
    ShopItem(
      id: 'acc_crown',
      name: 'Golden Crown',
      description: 'A royal crown for the focus king',
      category: ShopCategory.accessories,
      price: 50,
      assetPath: 'crown',
    ),
    ShopItem(
      id: 'acc_hat',
      name: 'Top Hat',
      description: 'Classy top hat for distinguished tomatoes',
      category: ShopCategory.accessories,
      price: 40,
      assetPath: 'tophat',
    ),
    ShopItem(
      id: 'acc_headphones',
      name: 'Headphones',
      description: 'Music lover headphones',
      category: ShopCategory.accessories,
      price: 35,
      assetPath: 'headphones',
    ),
    ShopItem(
      id: 'acc_bowtie',
      name: 'Bow Tie',
      description: 'Elegant bow tie accessory',
      category: ShopCategory.accessories,
      price: 25,
      assetPath: 'bowtie',
    ),
  ];

  static List<ShopItem> get all => [...sounds, ...backgrounds, ...accessories];
}
