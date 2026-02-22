/// Shop repository implementation.
///
/// Implements ShopRepository using static data.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/shop_category.dart';
import '../../domain/entities/shop_item.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/default_shop_items.dart';

/// Implementation of [ShopRepository] using static data.
class ShopRepositoryImpl implements ShopRepository {
  @override
  Future<Either<Failure, List<ShopItem>>> getAllItems() async {
    try {
      return Right(DefaultShopItems.all);
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load shop items',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ShopItem>>> getItemsByCategory(
    ShopCategory category,
  ) async {
    try {
      return Right(DefaultShopItems.byCategory(category));
    } catch (e) {
      return Left(
        Failure.unexpected(
          message: 'Failed to load category items',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ShopItem>> getItemById(String id) async {
    try {
      final item = DefaultShopItems.findById(id);
      if (item == null) {
        return Left(Failure.notFound(entityName: 'ShopItem', id: id));
      }
      return Right(item);
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to find item', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, List<ShopItem>>> searchItems(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      final results = DefaultShopItems.all.where((item) {
        return item.name.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery);
      }).toList();
      return Right(results);
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Search failed', originalError: e),
      );
    }
  }
}
