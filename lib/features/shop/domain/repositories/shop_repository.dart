/// Shop repository interface.
///
/// Defines the contract for shop data operations.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/shop_category.dart';
import '../entities/shop_item.dart';

/// Repository contract for shop operations.
abstract class ShopRepository {
  /// Gets all available shop items.
  Future<Either<Failure, List<ShopItem>>> getAllItems();

  /// Gets items by category.
  Future<Either<Failure, List<ShopItem>>> getItemsByCategory(
    ShopCategory category,
  );

  /// Gets a single item by ID.
  Future<Either<Failure, ShopItem>> getItemById(String id);

  /// Searches items by name.
  Future<Either<Failure, List<ShopItem>>> searchItems(String query);
}
