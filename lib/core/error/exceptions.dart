/// Data layer exceptions.
///
/// These exceptions are thrown by data sources and caught by repositories,
/// which then convert them to appropriate [Failure] types.
library;

/// Base exception for all data layer errors.
sealed class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.originalError, this.stackTrace});

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a cache/storage operation fails.
class CacheException extends AppException {
  const CacheException(super.message, {super.originalError, super.stackTrace});
}

/// Thrown when data parsing/serialization fails.
class SerializationException extends AppException {
  const SerializationException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when requested data is not found.
class NotFoundException extends AppException {
  final String entityName;
  final String? entityId;

  const NotFoundException(
    this.entityName, {
    this.entityId,
    super.originalError,
    super.stackTrace,
  }) : super(
         '$entityName not found${entityId != null ? ' (ID: $entityId)' : ''}',
       );
}

/// Thrown when data validation fails at the data layer.
class DataValidationException extends AppException {
  final String field;

  const DataValidationException(
    super.message, {
    required this.field,
    super.originalError,
    super.stackTrace,
  });
}
