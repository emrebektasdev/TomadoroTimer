/// Timer repository interface.
///
/// Defines the contract for persisting timer state.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/timer_snapshot.dart';

/// Repository contract for timer persistence.
abstract class TimerRepository {
  /// Saves the current timer state.
  Future<Either<Failure, Unit>> saveTimerState(TimerSnapshot state);

  /// Loads the persisted timer state.
  /// Returns null if no state is saved.
  Future<Either<Failure, TimerSnapshot?>> loadTimerState();

  /// Clears the persisted timer state (e.g., on reset).
  Future<Either<Failure, Unit>> clearTimerState();
}
