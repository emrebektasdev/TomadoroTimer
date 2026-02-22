/// Core failure types for domain layer error handling.
///
/// These failures represent business-level errors that can occur
/// across the application. They are used with [Either] from dartz
/// to provide type-safe error handling without exceptions.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base sealed class for all application failures.
@freezed
sealed class Failure with _$Failure {
  const Failure._();

  /// Storage operation failed (Hive, SharedPreferences, etc.)
  const factory Failure.cache({
    required String message,
    Object? originalError,
  }) = CacheFailure;

  /// Data validation failed
  const factory Failure.validation({
    required String message,
    required String field,
  }) = ValidationFailure;

  /// Unexpected error occurred
  const factory Failure.unexpected({
    required String message,
    Object? originalError,
  }) = UnexpectedFailure;

  /// Operation requires data that doesn't exist
  const factory Failure.notFound({required String entityName, String? id}) =
      NotFoundFailure;

  /// User-friendly error message
  String get displayMessage => when(
    cache: (message, _) => 'Storage error: $message',
    validation: (message, field) => '$field: $message',
    unexpected: (message, _) => 'Something went wrong: $message',
    notFound: (entity, id) =>
        '$entity not found${id != null ? ' (ID: $id)' : ''}',
  );
}
