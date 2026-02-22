/// Shop feature barrel export.
///
/// Import this file to access all shop feature exports.
library;

// Domain - Entities
export 'domain/entities/shop_category.dart';
export 'domain/entities/shop_item.dart';

// Domain - Repository interface
export 'domain/repositories/shop_repository.dart';

// Data - Default items
export 'data/datasources/default_shop_items.dart';

// Application - State & Providers
export 'application/shop_notifier.dart';
export 'application/shop_providers.dart';
export 'application/shop_state.dart';
