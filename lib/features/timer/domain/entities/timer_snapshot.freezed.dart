// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimerSnapshot {
  /// Current timer mode
  TimerMode get mode => throw _privateConstructorUsedError;

  /// Initial duration in minutes
  int get initialDuration => throw _privateConstructorUsedError;

  /// Remaining seconds at the time of snapshot
  int get remainingSeconds => throw _privateConstructorUsedError;

  /// Whether the timer was running
  bool get isRunning => throw _privateConstructorUsedError;

  /// Timestamp when the timer was started (if running)
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// Number of sessions completed (for long break logic)
  int get sessionsCompleted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimerSnapshotCopyWith<TimerSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerSnapshotCopyWith<$Res> {
  factory $TimerSnapshotCopyWith(
          TimerSnapshot value, $Res Function(TimerSnapshot) then) =
      _$TimerSnapshotCopyWithImpl<$Res, TimerSnapshot>;
  @useResult
  $Res call(
      {TimerMode mode,
      int initialDuration,
      int remainingSeconds,
      bool isRunning,
      DateTime? startTime,
      int sessionsCompleted});
}

/// @nodoc
class _$TimerSnapshotCopyWithImpl<$Res, $Val extends TimerSnapshot>
    implements $TimerSnapshotCopyWith<$Res> {
  _$TimerSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? initialDuration = null,
    Object? remainingSeconds = null,
    Object? isRunning = null,
    Object? startTime = freezed,
    Object? sessionsCompleted = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      initialDuration: null == initialDuration
          ? _value.initialDuration
          : initialDuration // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionsCompleted: null == sessionsCompleted
          ? _value.sessionsCompleted
          : sessionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerSnapshotImplCopyWith<$Res>
    implements $TimerSnapshotCopyWith<$Res> {
  factory _$$TimerSnapshotImplCopyWith(
          _$TimerSnapshotImpl value, $Res Function(_$TimerSnapshotImpl) then) =
      __$$TimerSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TimerMode mode,
      int initialDuration,
      int remainingSeconds,
      bool isRunning,
      DateTime? startTime,
      int sessionsCompleted});
}

/// @nodoc
class __$$TimerSnapshotImplCopyWithImpl<$Res>
    extends _$TimerSnapshotCopyWithImpl<$Res, _$TimerSnapshotImpl>
    implements _$$TimerSnapshotImplCopyWith<$Res> {
  __$$TimerSnapshotImplCopyWithImpl(
      _$TimerSnapshotImpl _value, $Res Function(_$TimerSnapshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? initialDuration = null,
    Object? remainingSeconds = null,
    Object? isRunning = null,
    Object? startTime = freezed,
    Object? sessionsCompleted = null,
  }) {
    return _then(_$TimerSnapshotImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as TimerMode,
      initialDuration: null == initialDuration
          ? _value.initialDuration
          : initialDuration // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionsCompleted: null == sessionsCompleted
          ? _value.sessionsCompleted
          : sessionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TimerSnapshotImpl implements _TimerSnapshot {
  const _$TimerSnapshotImpl(
      {required this.mode,
      required this.initialDuration,
      required this.remainingSeconds,
      required this.isRunning,
      this.startTime,
      this.sessionsCompleted = 0});

  /// Current timer mode
  @override
  final TimerMode mode;

  /// Initial duration in minutes
  @override
  final int initialDuration;

  /// Remaining seconds at the time of snapshot
  @override
  final int remainingSeconds;

  /// Whether the timer was running
  @override
  final bool isRunning;

  /// Timestamp when the timer was started (if running)
  @override
  final DateTime? startTime;

  /// Number of sessions completed (for long break logic)
  @override
  @JsonKey()
  final int sessionsCompleted;

  @override
  String toString() {
    return 'TimerSnapshot(mode: $mode, initialDuration: $initialDuration, remainingSeconds: $remainingSeconds, isRunning: $isRunning, startTime: $startTime, sessionsCompleted: $sessionsCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerSnapshotImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.initialDuration, initialDuration) ||
                other.initialDuration == initialDuration) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.sessionsCompleted, sessionsCompleted) ||
                other.sessionsCompleted == sessionsCompleted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, initialDuration,
      remainingSeconds, isRunning, startTime, sessionsCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerSnapshotImplCopyWith<_$TimerSnapshotImpl> get copyWith =>
      __$$TimerSnapshotImplCopyWithImpl<_$TimerSnapshotImpl>(this, _$identity);
}

abstract class _TimerSnapshot implements TimerSnapshot {
  const factory _TimerSnapshot(
      {required final TimerMode mode,
      required final int initialDuration,
      required final int remainingSeconds,
      required final bool isRunning,
      final DateTime? startTime,
      final int sessionsCompleted}) = _$TimerSnapshotImpl;

  @override

  /// Current timer mode
  TimerMode get mode;
  @override

  /// Initial duration in minutes
  int get initialDuration;
  @override

  /// Remaining seconds at the time of snapshot
  int get remainingSeconds;
  @override

  /// Whether the timer was running
  bool get isRunning;
  @override

  /// Timestamp when the timer was started (if running)
  DateTime? get startTime;
  @override

  /// Number of sessions completed (for long break logic)
  int get sessionsCompleted;
  @override
  @JsonKey(ignore: true)
  _$$TimerSnapshotImplCopyWith<_$TimerSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
