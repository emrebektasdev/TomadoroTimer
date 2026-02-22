// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WeeklyStats {
  /// Start date of the week (Monday)
  DateTime get weekStart => throw _privateConstructorUsedError;

  /// Total focus minutes for the week
  int get totalMinutes => throw _privateConstructorUsedError;

  /// Number of completed sessions
  int get sessionsCompleted => throw _privateConstructorUsedError;

  /// Tomatoes earned this week
  int get tomatoesEarned => throw _privateConstructorUsedError;

  /// Days with activity this week (0-7)
  int get activeDays => throw _privateConstructorUsedError;

  /// Weekly goal in minutes
  int get goalMinutes => throw _privateConstructorUsedError;

  /// Per-day breakdown (Mon-Sun, 7 values)
  List<int> get dailyMinutes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WeeklyStatsCopyWith<WeeklyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyStatsCopyWith<$Res> {
  factory $WeeklyStatsCopyWith(
          WeeklyStats value, $Res Function(WeeklyStats) then) =
      _$WeeklyStatsCopyWithImpl<$Res, WeeklyStats>;
  @useResult
  $Res call(
      {DateTime weekStart,
      int totalMinutes,
      int sessionsCompleted,
      int tomatoesEarned,
      int activeDays,
      int goalMinutes,
      List<int> dailyMinutes});
}

/// @nodoc
class _$WeeklyStatsCopyWithImpl<$Res, $Val extends WeeklyStats>
    implements $WeeklyStatsCopyWith<$Res> {
  _$WeeklyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? totalMinutes = null,
    Object? sessionsCompleted = null,
    Object? tomatoesEarned = null,
    Object? activeDays = null,
    Object? goalMinutes = null,
    Object? dailyMinutes = null,
  }) {
    return _then(_value.copyWith(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      activeDays: null == activeDays
          ? _value.activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as int,
      goalMinutes: null == goalMinutes
          ? _value.goalMinutes
          : goalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      dailyMinutes: null == dailyMinutes
          ? _value.dailyMinutes
          : dailyMinutes // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyStatsImplCopyWith<$Res>
    implements $WeeklyStatsCopyWith<$Res> {
  factory _$$WeeklyStatsImplCopyWith(
          _$WeeklyStatsImpl value, $Res Function(_$WeeklyStatsImpl) then) =
      __$$WeeklyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime weekStart,
      int totalMinutes,
      int sessionsCompleted,
      int tomatoesEarned,
      int activeDays,
      int goalMinutes,
      List<int> dailyMinutes});
}

/// @nodoc
class __$$WeeklyStatsImplCopyWithImpl<$Res>
    extends _$WeeklyStatsCopyWithImpl<$Res, _$WeeklyStatsImpl>
    implements _$$WeeklyStatsImplCopyWith<$Res> {
  __$$WeeklyStatsImplCopyWithImpl(
      _$WeeklyStatsImpl _value, $Res Function(_$WeeklyStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? totalMinutes = null,
    Object? sessionsCompleted = null,
    Object? tomatoesEarned = null,
    Object? activeDays = null,
    Object? goalMinutes = null,
    Object? dailyMinutes = null,
  }) {
    return _then(_$WeeklyStatsImpl(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      activeDays: null == activeDays
          ? _value.activeDays
          : activeDays // ignore: cast_nullable_to_non_nullable
              as int,
      goalMinutes: null == goalMinutes
          ? _value.goalMinutes
          : goalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      dailyMinutes: null == dailyMinutes
          ? _value._dailyMinutes
          : dailyMinutes // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$WeeklyStatsImpl extends _WeeklyStats {
  const _$WeeklyStatsImpl(
      {required this.weekStart,
      this.totalMinutes = 0,
      this.sessionsCompleted = 0,
      this.tomatoesEarned = 0,
      this.activeDays = 0,
      this.goalMinutes = 500,
      final List<int> dailyMinutes = const [0, 0, 0, 0, 0, 0, 0]})
      : _dailyMinutes = dailyMinutes,
        super._();

  /// Start date of the week (Monday)
  @override
  final DateTime weekStart;

  /// Total focus minutes for the week
  @override
  @JsonKey()
  final int totalMinutes;

  /// Number of completed sessions
  @override
  @JsonKey()
  final int sessionsCompleted;

  /// Tomatoes earned this week
  @override
  @JsonKey()
  final int tomatoesEarned;

  /// Days with activity this week (0-7)
  @override
  @JsonKey()
  final int activeDays;

  /// Weekly goal in minutes
  @override
  @JsonKey()
  final int goalMinutes;

  /// Per-day breakdown (Mon-Sun, 7 values)
  final List<int> _dailyMinutes;

  /// Per-day breakdown (Mon-Sun, 7 values)
  @override
  @JsonKey()
  List<int> get dailyMinutes {
    if (_dailyMinutes is EqualUnmodifiableListView) return _dailyMinutes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyMinutes);
  }

  @override
  String toString() {
    return 'WeeklyStats(weekStart: $weekStart, totalMinutes: $totalMinutes, sessionsCompleted: $sessionsCompleted, tomatoesEarned: $tomatoesEarned, activeDays: $activeDays, goalMinutes: $goalMinutes, dailyMinutes: $dailyMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyStatsImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.sessionsCompleted, sessionsCompleted) ||
                other.sessionsCompleted == sessionsCompleted) &&
            (identical(other.tomatoesEarned, tomatoesEarned) ||
                other.tomatoesEarned == tomatoesEarned) &&
            (identical(other.activeDays, activeDays) ||
                other.activeDays == activeDays) &&
            (identical(other.goalMinutes, goalMinutes) ||
                other.goalMinutes == goalMinutes) &&
            const DeepCollectionEquality()
                .equals(other._dailyMinutes, _dailyMinutes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weekStart,
      totalMinutes,
      sessionsCompleted,
      tomatoesEarned,
      activeDays,
      goalMinutes,
      const DeepCollectionEquality().hash(_dailyMinutes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      __$$WeeklyStatsImplCopyWithImpl<_$WeeklyStatsImpl>(this, _$identity);
}

abstract class _WeeklyStats extends WeeklyStats {
  const factory _WeeklyStats(
      {required final DateTime weekStart,
      final int totalMinutes,
      final int sessionsCompleted,
      final int tomatoesEarned,
      final int activeDays,
      final int goalMinutes,
      final List<int> dailyMinutes}) = _$WeeklyStatsImpl;
  const _WeeklyStats._() : super._();

  @override

  /// Start date of the week (Monday)
  DateTime get weekStart;
  @override

  /// Total focus minutes for the week
  int get totalMinutes;
  @override

  /// Number of completed sessions
  int get sessionsCompleted;
  @override

  /// Tomatoes earned this week
  int get tomatoesEarned;
  @override

  /// Days with activity this week (0-7)
  int get activeDays;
  @override

  /// Weekly goal in minutes
  int get goalMinutes;
  @override

  /// Per-day breakdown (Mon-Sun, 7 values)
  List<int> get dailyMinutes;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
