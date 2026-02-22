// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyStats {
  /// Date in YYYY-MM-DD format
  String get dateKey => throw _privateConstructorUsedError;

  /// Total focus minutes for the day
  int get totalMinutes => throw _privateConstructorUsedError;

  /// Number of completed sessions
  int get sessionsCompleted => throw _privateConstructorUsedError;

  /// Tomatoes earned on this day
  int get tomatoesEarned => throw _privateConstructorUsedError;

  /// Daily goal in minutes (at time of recording)
  int get goalMinutes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyStatsCopyWith<DailyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatsCopyWith<$Res> {
  factory $DailyStatsCopyWith(
          DailyStats value, $Res Function(DailyStats) then) =
      _$DailyStatsCopyWithImpl<$Res, DailyStats>;
  @useResult
  $Res call(
      {String dateKey,
      int totalMinutes,
      int sessionsCompleted,
      int tomatoesEarned,
      int goalMinutes});
}

/// @nodoc
class _$DailyStatsCopyWithImpl<$Res, $Val extends DailyStats>
    implements $DailyStatsCopyWith<$Res> {
  _$DailyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateKey = null,
    Object? totalMinutes = null,
    Object? sessionsCompleted = null,
    Object? tomatoesEarned = null,
    Object? goalMinutes = null,
  }) {
    return _then(_value.copyWith(
      dateKey: null == dateKey
          ? _value.dateKey
          : dateKey // ignore: cast_nullable_to_non_nullable
              as String,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsCompleted: null == sessionsCompleted
          ? _value.sessionsCompleted
          : sessionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      tomatoesEarned: null == tomatoesEarned
          ? _value.tomatoesEarned
          : tomatoesEarned // ignore: cast_nullable_to_non_nullable
              as int,
      goalMinutes: null == goalMinutes
          ? _value.goalMinutes
          : goalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyStatsImplCopyWith<$Res>
    implements $DailyStatsCopyWith<$Res> {
  factory _$$DailyStatsImplCopyWith(
          _$DailyStatsImpl value, $Res Function(_$DailyStatsImpl) then) =
      __$$DailyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dateKey,
      int totalMinutes,
      int sessionsCompleted,
      int tomatoesEarned,
      int goalMinutes});
}

/// @nodoc
class __$$DailyStatsImplCopyWithImpl<$Res>
    extends _$DailyStatsCopyWithImpl<$Res, _$DailyStatsImpl>
    implements _$$DailyStatsImplCopyWith<$Res> {
  __$$DailyStatsImplCopyWithImpl(
      _$DailyStatsImpl _value, $Res Function(_$DailyStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateKey = null,
    Object? totalMinutes = null,
    Object? sessionsCompleted = null,
    Object? tomatoesEarned = null,
    Object? goalMinutes = null,
  }) {
    return _then(_$DailyStatsImpl(
      dateKey: null == dateKey
          ? _value.dateKey
          : dateKey // ignore: cast_nullable_to_non_nullable
              as String,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsCompleted: null == sessionsCompleted
          ? _value.sessionsCompleted
          : sessionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      tomatoesEarned: null == tomatoesEarned
          ? _value.tomatoesEarned
          : tomatoesEarned // ignore: cast_nullable_to_non_nullable
              as int,
      goalMinutes: null == goalMinutes
          ? _value.goalMinutes
          : goalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DailyStatsImpl extends _DailyStats {
  const _$DailyStatsImpl(
      {required this.dateKey,
      this.totalMinutes = 0,
      this.sessionsCompleted = 0,
      this.tomatoesEarned = 0,
      this.goalMinutes = 100})
      : super._();

  /// Date in YYYY-MM-DD format
  @override
  final String dateKey;

  /// Total focus minutes for the day
  @override
  @JsonKey()
  final int totalMinutes;

  /// Number of completed sessions
  @override
  @JsonKey()
  final int sessionsCompleted;

  /// Tomatoes earned on this day
  @override
  @JsonKey()
  final int tomatoesEarned;

  /// Daily goal in minutes (at time of recording)
  @override
  @JsonKey()
  final int goalMinutes;

  @override
  String toString() {
    return 'DailyStats(dateKey: $dateKey, totalMinutes: $totalMinutes, sessionsCompleted: $sessionsCompleted, tomatoesEarned: $tomatoesEarned, goalMinutes: $goalMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatsImpl &&
            (identical(other.dateKey, dateKey) || other.dateKey == dateKey) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.sessionsCompleted, sessionsCompleted) ||
                other.sessionsCompleted == sessionsCompleted) &&
            (identical(other.tomatoesEarned, tomatoesEarned) ||
                other.tomatoesEarned == tomatoesEarned) &&
            (identical(other.goalMinutes, goalMinutes) ||
                other.goalMinutes == goalMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dateKey, totalMinutes,
      sessionsCompleted, tomatoesEarned, goalMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      __$$DailyStatsImplCopyWithImpl<_$DailyStatsImpl>(this, _$identity);
}

abstract class _DailyStats extends DailyStats {
  const factory _DailyStats(
      {required final String dateKey,
      final int totalMinutes,
      final int sessionsCompleted,
      final int tomatoesEarned,
      final int goalMinutes}) = _$DailyStatsImpl;
  const _DailyStats._() : super._();

  @override

  /// Date in YYYY-MM-DD format
  String get dateKey;
  @override

  /// Total focus minutes for the day
  int get totalMinutes;
  @override

  /// Number of completed sessions
  int get sessionsCompleted;
  @override

  /// Tomatoes earned on this day
  int get tomatoesEarned;
  @override

  /// Daily goal in minutes (at time of recording)
  int get goalMinutes;
  @override
  @JsonKey(ignore: true)
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
