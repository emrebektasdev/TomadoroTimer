/// User feature barrel export.
///
/// Import this file to access all user feature exports.
library;

// Domain - Entities
export 'domain/entities/equipped_items.dart';
export 'domain/entities/user_profile.dart';
export 'domain/entities/user_settings.dart';

// Domain - Repository interface
export 'domain/repositories/user_repository.dart';

// Application - State & Providers
export 'application/user_notifier.dart';
export 'application/user_providers.dart';
export 'application/user_state.dart';
