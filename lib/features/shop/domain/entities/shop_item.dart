/// Shop item domain entity.
///
/// Represents a purchasable item in the shop.
/// Note: isPurchased and isEquipped are NOT part of the entity -
/// those are runtime states managed by UserState.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'shop_category.dart';

part 'shop_item.freezed.dart';

/// A shop item definition (static data).
@freezed
class ShopItem with _$ShopItem {
  const factory ShopItem({
    /// Unique identifier (e.g., 'sound_rain', 'bg_sunset')
    required String id,

    /// Display name
    required String name,

    /// Description text
    required String description,

    /// Item category
    required ShopCategory category,

    /// Price in tomatoes
    required int price,

    /// Asset path or identifier
    String? assetPath,
  }) = _ShopItem;

  const ShopItem._();

  /// Whether this is a sound item
  bool get isSound => category == ShopCategory.sounds;

  /// Whether this is a background item
  bool get isBackground => category == ShopCategory.backgrounds;

  /// Whether this is an accessory item
  bool get isAccessory => category == ShopCategory.accessories;
}
