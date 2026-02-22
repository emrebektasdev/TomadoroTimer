/// Type aliases for common types used throughout the application.
///
/// These aliases improve readability and provide a single place
/// to change types if needed.
library;

import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Result type for operations that can fail.
///
/// Use this instead of returning `Future<T?>` or throwing exceptions.
/// Left = Failure, Right = Success value.
typedef Result<T> = Either<Failure, T>;

/// Result type for operations that can fail (async version).
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// Result type for operations that return nothing on success.
typedef FutureVoidResult = Future<Either<Failure, Unit>>;

/// Callback type for async operations.
typedef AsyncCallback = Future<void> Function();

/// Callback with a result.
typedef ResultCallback<T> = void Function(Result<T> result);
