/// Timer repository implementation.
///
/// Implements TimerRepository using Hive persistence.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/timer_snapshot.dart';
import '../../domain/repositories/timer_repository.dart';
import '../datasources/timer_local_datasource.dart';

/// Implementation of [TimerRepository].
class TimerRepositoryImpl implements TimerRepository {
  final TimerLocalDataSource _localDataSource;

  TimerRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> saveTimerState(TimerSnapshot state) async {
    try {
      await _localDataSource.saveTimerSnapshot(state);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to save timer', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, TimerSnapshot?>> loadTimerState() async {
    try {
      final snapshot = _localDataSource.loadTimerSnapshot();
      return Right(snapshot);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to load timer', originalError: e),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearTimerState() async {
    try {
      await _localDataSource.clearTimerSnapshot();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message, originalError: e));
    } catch (e) {
      return Left(
        Failure.unexpected(message: 'Failed to clear timer', originalError: e),
      );
    }
  }
}
