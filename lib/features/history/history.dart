/// History feature barrel export.
///
/// Import this file to access all history feature exports.
library;

// Domain - Entities
export 'domain/entities/daily_stats.dart';
export 'domain/entities/focus_session.dart';
export 'domain/entities/weekly_stats.dart';

// Domain - Repository interface
export 'domain/repositories/history_repository.dart';

// Application - State & Providers
export 'application/history_notifier.dart';
export 'application/history_providers.dart';
export 'application/history_state.dart';
