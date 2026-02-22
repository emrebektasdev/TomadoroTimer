// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FocusSession {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// When the session started
  DateTime get startTime => throw _privateConstructorUsedError;

  /// When the session ended
  DateTime get endTime => throw _privateConstructorUsedError;

  /// Duration of the session in minutes
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Number of tomatoes earned
  int get tomatoesEarned => throw _privateConstructorUsedError;

  /// Whether the session was completed (not abandoned)
  bool get completed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FocusSessionCopyWith<FocusSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusSessionCopyWith<$Res> {
  factory $FocusSessionCopyWith(
          FocusSession value, $Res Function(FocusSession) then) =
      _$FocusSessionCopyWithImpl<$Res, FocusSession>;
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      int durationMinutes,
      int tomatoesEarned,
      bool completed});
}

/// @nodoc
class _$FocusSessionCopyWithImpl<$Res, $Val extends FocusSession>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? durationMinutes = null,
    Object? tomatoesEarned = null,
    Object? completed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      tomatoesEarned: null == tomatoesEarned
          ? _value.tomatoesEarned
          : tomatoesEarned // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FocusSessionImplCopyWith<$Res>
    implements $FocusSessionCopyWith<$Res> {
  factory _$$FocusSessionImplCopyWith(
          _$FocusSessionImpl value, $Res Function(_$FocusSessionImpl) then) =
      __$$FocusSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startTime,
      DateTime endTime,
      int durationMinutes,
      int tomatoesEarned,
      bool completed});
}

/// @nodoc
class __$$FocusSessionImplCopyWithImpl<$Res>
    extends _$FocusSessionCopyWithImpl<$Res, _$FocusSessionImpl>
    implements _$$FocusSessionImplCopyWith<$Res> {
  __$$FocusSessionImplCopyWithImpl(
      _$FocusSessionImpl _value, $Res Function(_$FocusSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? durationMinutes = null,
    Object? tomatoesEarned = null,
    Object? completed = null,
  }) {
    return _then(_$FocusSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      tomatoesEarned: null == tomatoesEarned
          ? _value.tomatoesEarned
          : tomatoesEarned // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FocusSessionImpl extends _FocusSession {
  const _$FocusSessionImpl(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.durationMinutes,
      required this.tomatoesEarned,
      this.completed = true})
      : super._();

  /// Unique identifier
  @override
  final String id;

  /// When the session started
  @override
  final DateTime startTime;

  /// When the session ended
  @override
  final DateTime endTime;

  /// Duration of the session in minutes
  @override
  final int durationMinutes;

  /// Number of tomatoes earned
  @override
  final int tomatoesEarned;

  /// Whether the session was completed (not abandoned)
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'FocusSession(id: $id, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, tomatoesEarned: $tomatoesEarned, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.tomatoesEarned, tomatoesEarned) ||
                other.tomatoesEarned == tomatoesEarned) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime,
      durationMinutes, tomatoesEarned, completed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      __$$FocusSessionImplCopyWithImpl<_$FocusSessionImpl>(this, _$identity);
}

abstract class _FocusSession extends FocusSession {
  const factory _FocusSession(
      {required final String id,
      required final DateTime startTime,
      required final DateTime endTime,
      required final int durationMinutes,
      required final int tomatoesEarned,
      final bool completed}) = _$FocusSessionImpl;
  const _FocusSession._() : super._();

  @override

  /// Unique identifier
  String get id;
  @override

  /// When the session started
  DateTime get startTime;
  @override

  /// When the session ended
  DateTime get endTime;
  @override

  /// Duration of the session in minutes
  int get durationMinutes;
  @override

  /// Number of tomatoes earned
  int get tomatoesEarned;
  @override

  /// Whether the session was completed (not abandoned)
  bool get completed;
  @override
  @JsonKey(ignore: true)
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
