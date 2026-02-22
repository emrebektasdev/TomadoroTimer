/// User equipped items domain entity.
///
/// Tracks which cosmetic items the user has equipped.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipped_items.freezed.dart';

/// Currently equipped cosmetic items.
@freezed
class EquippedItems with _$EquippedItems {
  const factory EquippedItems({
    /// Currently equipped accessory ID (e.g., 'acc_sunglasses')
    String? accessoryId,

    /// Currently equipped background ID (e.g., 'bg_sunset')
    String? backgroundId,

    /// Currently equipped sound ID (e.g., 'sound_rain')
    String? soundId,
  }) = _EquippedItems;

  const EquippedItems._();

  /// Creates empty equipped items (nothing equipped).
  factory EquippedItems.none() => const EquippedItems();

  /// Whether any item is equipped.
  bool get hasAnyEquipped =>
      accessoryId != null || backgroundId != null || soundId != null;
}
