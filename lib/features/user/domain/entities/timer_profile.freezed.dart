// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TimerProfile {
  /// Unique identifier for the profile
  String get id => throw _privateConstructorUsedError;

  /// Display name of the profile
  String get name => throw _privateConstructorUsedError;

  /// Focus session duration in minutes
  int get focusDurationMinutes => throw _privateConstructorUsedError;

  /// Short break duration in minutes
  int get shortBreakMinutes => throw _privateConstructorUsedError;

  /// Long break duration in minutes
  int get longBreakMinutes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimerProfileCopyWith<TimerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerProfileCopyWith<$Res> {
  factory $TimerProfileCopyWith(
          TimerProfile value, $Res Function(TimerProfile) then) =
      _$TimerProfileCopyWithImpl<$Res, TimerProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      int focusDurationMinutes,
      int shortBreakMinutes,
      int longBreakMinutes});
}

/// @nodoc
class _$TimerProfileCopyWithImpl<$Res, $Val extends TimerProfile>
    implements $TimerProfileCopyWith<$Res> {
  _$TimerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? focusDurationMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      focusDurationMinutes: null == focusDurationMinutes
          ? _value.focusDurationMinutes
          : focusDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimerProfileImplCopyWith<$Res>
    implements $TimerProfileCopyWith<$Res> {
  factory _$$TimerProfileImplCopyWith(
          _$TimerProfileImpl value, $Res Function(_$TimerProfileImpl) then) =
      __$$TimerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int focusDurationMinutes,
      int shortBreakMinutes,
      int longBreakMinutes});
}

/// @nodoc
class __$$TimerProfileImplCopyWithImpl<$Res>
    extends _$TimerProfileCopyWithImpl<$Res, _$TimerProfileImpl>
    implements _$$TimerProfileImplCopyWith<$Res> {
  __$$TimerProfileImplCopyWithImpl(
      _$TimerProfileImpl _value, $Res Function(_$TimerProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? focusDurationMinutes = null,
    Object? shortBreakMinutes = null,
    Object? longBreakMinutes = null,
  }) {
    return _then(_$TimerProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      focusDurationMinutes: null == focusDurationMinutes
          ? _value.focusDurationMinutes
          : focusDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakMinutes: null == shortBreakMinutes
          ? _value.shortBreakMinutes
          : shortBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      longBreakMinutes: null == longBreakMinutes
          ? _value.longBreakMinutes
          : longBreakMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TimerProfileImpl extends _TimerProfile {
  const _$TimerProfileImpl(
      {required this.id,
      required this.name,
      required this.focusDurationMinutes,
      required this.shortBreakMinutes,
      required this.longBreakMinutes})
      : super._();

  /// Unique identifier for the profile
  @override
  final String id;

  /// Display name of the profile
  @override
  final String name;

  /// Focus session duration in minutes
  @override
  final int focusDurationMinutes;

  /// Short break duration in minutes
  @override
  final int shortBreakMinutes;

  /// Long break duration in minutes
  @override
  final int longBreakMinutes;

  @override
  String toString() {
    return 'TimerProfile(id: $id, name: $name, focusDurationMinutes: $focusDurationMinutes, shortBreakMinutes: $shortBreakMinutes, longBreakMinutes: $longBreakMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.focusDurationMinutes, focusDurationMinutes) ||
                other.focusDurationMinutes == focusDurationMinutes) &&
            (identical(other.shortBreakMinutes, shortBreakMinutes) ||
                other.shortBreakMinutes == shortBreakMinutes) &&
            (identical(other.longBreakMinutes, longBreakMinutes) ||
                other.longBreakMinutes == longBreakMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, focusDurationMinutes,
      shortBreakMinutes, longBreakMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerProfileImplCopyWith<_$TimerProfileImpl> get copyWith =>
      __$$TimerProfileImplCopyWithImpl<_$TimerProfileImpl>(this, _$identity);
}

abstract class _TimerProfile extends TimerProfile {
  const factory _TimerProfile(
      {required final String id,
      required final String name,
      required final int focusDurationMinutes,
      required final int shortBreakMinutes,
      required final int longBreakMinutes}) = _$TimerProfileImpl;
  const _TimerProfile._() : super._();

  @override

  /// Unique identifier for the profile
  String get id;
  @override

  /// Display name of the profile
  String get name;
  @override

  /// Focus session duration in minutes
  int get focusDurationMinutes;
  @override

  /// Short break duration in minutes
  int get shortBreakMinutes;
  @override

  /// Long break duration in minutes
  int get longBreakMinutes;
  @override
  @JsonKey(ignore: true)
  _$$TimerProfileImplCopyWith<_$TimerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
