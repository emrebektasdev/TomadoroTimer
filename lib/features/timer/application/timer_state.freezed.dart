// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimerState {
  /// Current timer mode
  TimerMode get mode => throw _privateConstructorUsedError;

  /// Initial duration in minutes
  int get initialDuration => throw _privateConstructorUsedError;

  /// Remaining seconds to display
  int get remainingSeconds => throw _privateConstructorUsedError;

  /// Whether the timer is currently running
  bool get isRunning => throw _privateConstructorUsedError;

  /// Start timestamp (null if paused/stopped)
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// Number of sessions completed (for auto-break logic)
  int get sessionsCompleted => throw _privateConstructorUsedError;

  /// Whether the timer is currently loading/restoring
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether the current session is effectively complete (reached 0)
  /// Used to trigger completion logic only once.
  bool get isCompleted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimerStateCopyWith<TimerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerStateCopyWith<$Res> {
  factory $TimerStateCopyWith(
          TimerState value, $Res Function(TimerState) then) =
      _$TimerStateCopyWithImpl<$Res, TimerState>;
  @useResult
  $Res call(
      {TimerMode mode,
      int initialDuration,
      int remainingSeconds,
      bool isRunning,
      DateTime? startTime,
      int sessionsCompleted,
      bool isLoading,
      bool isCompleted});
}

/// @nodoc
class _$TimerStateCopyWithImpl<$Res, $Val extends TimerState>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._value, this._then);

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
    Object? isLoading = null,
    Object? isCompleted = null,
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
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerStateImplCopyWith<$Res>
    implements $TimerStateCopyWith<$Res> {
  factory _$$TimerStateImplCopyWith(
          _$TimerStateImpl value, $Res Function(_$TimerStateImpl) then) =
      __$$TimerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TimerMode mode,
      int initialDuration,
      int remainingSeconds,
      bool isRunning,
      DateTime? startTime,
      int sessionsCompleted,
      bool isLoading,
      bool isCompleted});
}

/// @nodoc
class __$$TimerStateImplCopyWithImpl<$Res>
    extends _$TimerStateCopyWithImpl<$Res, _$TimerStateImpl>
    implements _$$TimerStateImplCopyWith<$Res> {
  __$$TimerStateImplCopyWithImpl(
      _$TimerStateImpl _value, $Res Function(_$TimerStateImpl) _then)
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
    Object? isLoading = null,
    Object? isCompleted = null,
  }) {
    return _then(_$TimerStateImpl(
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
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TimerStateImpl extends _TimerState {
  const _$TimerStateImpl(
      {required this.mode,
      required this.initialDuration,
      required this.remainingSeconds,
      required this.isRunning,
      this.startTime,
      this.sessionsCompleted = 0,
      this.isLoading = false,
      this.isCompleted = false})
      : super._();

  /// Current timer mode
  @override
  final TimerMode mode;

  /// Initial duration in minutes
  @override
  final int initialDuration;

  /// Remaining seconds to display
  @override
  final int remainingSeconds;

  /// Whether the timer is currently running
  @override
  final bool isRunning;

  /// Start timestamp (null if paused/stopped)
  @override
  final DateTime? startTime;

  /// Number of sessions completed (for auto-break logic)
  @override
  @JsonKey()
  final int sessionsCompleted;

  /// Whether the timer is currently loading/restoring
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether the current session is effectively complete (reached 0)
  /// Used to trigger completion logic only once.
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'TimerState(mode: $mode, initialDuration: $initialDuration, remainingSeconds: $remainingSeconds, isRunning: $isRunning, startTime: $startTime, sessionsCompleted: $sessionsCompleted, isLoading: $isLoading, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerStateImpl &&
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
                other.sessionsCompleted == sessionsCompleted) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      initialDuration,
      remainingSeconds,
      isRunning,
      startTime,
      sessionsCompleted,
      isLoading,
      isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerStateImplCopyWith<_$TimerStateImpl> get copyWith =>
      __$$TimerStateImplCopyWithImpl<_$TimerStateImpl>(this, _$identity);
}

abstract class _TimerState extends TimerState {
  const factory _TimerState(
      {required final TimerMode mode,
      required final int initialDuration,
      required final int remainingSeconds,
      required final bool isRunning,
      final DateTime? startTime,
      final int sessionsCompleted,
      final bool isLoading,
      final bool isCompleted}) = _$TimerStateImpl;
  const _TimerState._() : super._();

  @override

  /// Current timer mode
  TimerMode get mode;
  @override

  /// Initial duration in minutes
  int get initialDuration;
  @override

  /// Remaining seconds to display
  int get remainingSeconds;
  @override

  /// Whether the timer is currently running
  bool get isRunning;
  @override

  /// Start timestamp (null if paused/stopped)
  DateTime? get startTime;
  @override

  /// Number of sessions completed (for auto-break logic)
  int get sessionsCompleted;
  @override

  /// Whether the timer is currently loading/restoring
  bool get isLoading;
  @override

  /// Whether the current session is effectively complete (reached 0)
  /// Used to trigger completion logic only once.
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$TimerStateImplCopyWith<_$TimerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
