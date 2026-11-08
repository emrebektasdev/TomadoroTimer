/// Default shop items - static data source.
///
/// All available items in the shop are defined here.
library;

import '../../domain/entities/shop_category.dart';
import '../../domain/entities/shop_item.dart';

/// Static data source for shop items.
abstract final class DefaultShopItems {
  static const sunnyGreenhouse = ShopItem(
    id: 'bg_sunny',
    name: 'Güneşli Sera',
    description: 'Gün ışığıyla dolu bir sabah serası.',
    category: ShopCategory.backgrounds,
    price: 0,
    assetPath: 'assets/images/morning_greenhouse.png',
  );

  /// Sound items
  static const List<ShopItem> sounds = [
    ShopItem(
      id: 'sound_rain',
      name: 'Camda yağmur',
      description: 'Relaxing rain ambience for deep focus',
      category: ShopCategory.sounds,
      price: 0,
      assetPath: 'assets/sounds/rain.mp3',
    ),
    ShopItem(
      id: 'sound_forest',
      name: 'Orman esintisi',
      description: 'Peaceful forest with birds chirping',
      category: ShopCategory.sounds,
      price: 15,
      assetPath: 'assets/sounds/forest.mp3',
    ),
    ShopItem(
      id: 'sound_ocean',
      name: 'Okyanus dalgaları',
      description: 'Calm ocean waves for serenity',
      category: ShopCategory.sounds,
      price: 15,
      assetPath: 'assets/sounds/ocean.mp3',
    ),
    ShopItem(
      id: 'sound_cafe',
      name: 'Kafe uğultusu',
      description: 'Coffee shop background noise',
      category: ShopCategory.sounds,
      price: 0,
      assetPath: 'assets/sounds/cafe.mp3',
    ),
    ShopItem(
      id: 'sound_fireplace',
      name: 'Şömine çıtırtısı',
      description: 'Cozy crackling fireplace sounds',
      category: ShopCategory.sounds,
      price: 20,
      assetPath: 'assets/sounds/fireplace.mp3',
    ),
  ];

  /// Background items
  static const List<ShopItem> backgrounds = [
    ShopItem(
      id: 'bg_forest',
      name: 'Yağmurlu Sera',
      description: 'Yağmur damlaları, ortancalar ve fener ışığı.',
      category: ShopCategory.backgrounds,
      price: 30,
      assetPath: 'assets/images/rainy_greenhouse.png',
    ),
    ShopItem(
      id: 'bg_night',
      name: 'Ay Işığı',
      description: 'Yıldızların altında ışıkları yanan bir köy.',
      category: ShopCategory.backgrounds,
      price: 25,
      assetPath: 'assets/images/moonlight.png',
    ),
    ShopItem(
      id: 'bg_sunset',
      name: 'Sonbahar Bahçesi',
      description: 'Altın yapraklar arasında güneşli bir bahçe yolu.',
      category: ShopCategory.backgrounds,
      price: 25,
      assetPath: 'assets/images/autumn_garden.png',
    ),
    ShopItem(
      id: 'bg_ocean',
      name: 'Kış Kulübesi',
      description: 'Kar yağışını izlemek için sıcacık bir pencere.',
      category: ShopCategory.backgrounds,
      price: 30,
      assetPath: 'assets/images/winter_cabin.png',
    ),
  ];

  static ShopItem backgroundFor(String? id) {
    for (final item in backgrounds) {
      if (item.id == id) return item;
    }
    return sunnyGreenhouse;
  }

  /// Accessory items
  static const List<ShopItem> accessories = [
    ShopItem(
      id: 'acc_sunglasses',
      name: 'Yuvarlak gözlük',
      description: 'Cool sunglasses for your tomato',
      category: ShopCategory.accessories,
      price: 0,
      assetPath: 'sunglasses',
    ),
    ShopItem(
      id: 'acc_scarf',
      name: 'Örgü atkı',
      description: 'Cozy knitted scarf for chilly focus days',
      category: ShopCategory.accessories,
      price: 2,
      assetPath: 'scarf',
    ),
    ShopItem(
      id: 'acc_eyepatch',
      name: 'Korsan göz bandı',
      description: 'Arrr! A pirate eye patch',
      category: ShopCategory.accessories,
      price: 35,
      assetPath: 'eyepatch',
    ),
    ShopItem(
      id: 'acc_crown',
      name: 'Altın taç',
      description: 'A royal crown for the focus king',
      category: ShopCategory.accessories,
      price: 50,
      assetPath: 'crown',
    ),
    ShopItem(
      id: 'acc_hat',
      name: 'Silindir şapka',
      description: 'Classy top hat for distinguished tomatoes',
      category: ShopCategory.accessories,
      price: 40,
      assetPath: 'tophat',
    ),
    ShopItem(
      id: 'acc_headphones',
      name: 'Kulaklık',
      description: 'Music lover headphones',
      category: ShopCategory.accessories,
      price: 4,
      assetPath: 'headphones',
    ),
    ShopItem(
      id: 'acc_bowtie',
      name: 'Papyon',
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
