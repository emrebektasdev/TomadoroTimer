/// Default shop items - static data source.
///
/// All available items in the shop are defined here.
library;

import '../../domain/entities/shop_category.dart';
import '../../domain/entities/shop_item.dart';

/// Static data source for shop items.
abstract final class DefaultShopItems {
  /// Sound items
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

  /// Background items
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

  /// Accessory items
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

  /// All items combined
  static List<ShopItem> get all => [...sounds, ...backgrounds, ...accessories];

  /// Get items by category
  static List<ShopItem> byCategory(ShopCategory category) {
    switch (category) {
      case ShopCategory.sounds:
        return sounds;
      case ShopCategory.backgrounds:
        return backgrounds;
      case ShopCategory.accessories:
        return accessories;
    }
  }

  /// Find item by ID
  static ShopItem? findById(String id) {
    try {
      return all.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
