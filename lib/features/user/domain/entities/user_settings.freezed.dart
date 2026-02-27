// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSettings {
  /// Whether push notifications are enabled
  bool get notificationsEnabled => throw _privateConstructorUsedError;

  /// Whether sounds are enabled
  bool get soundEnabled => throw _privateConstructorUsedError;

  /// Whether vibration feedback is enabled
  bool get vibrationEnabled => throw _privateConstructorUsedError;

  /// Daily focus goal in minutes (default: 100 = 25 * 4)
  int get dailyGoalMinutes => throw _privateConstructorUsedError;

  /// Weekly focus goal in minutes (default: 500 = 25 * 20)
  int get weeklyGoalMinutes => throw _privateConstructorUsedError;

  /// List of available timer profiles
  List<TimerProfile> get profiles => throw _privateConstructorUsedError;

  /// ID of the currently active timer profile
  String get activeProfileId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {bool notificationsEnabled,
      bool soundEnabled,
      bool vibrationEnabled,
      int dailyGoalMinutes,
      int weeklyGoalMinutes,
      List<TimerProfile> profiles,
      String activeProfileId});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsEnabled = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? dailyGoalMinutes = null,
    Object? weeklyGoalMinutes = null,
    Object? profiles = null,
    Object? activeProfileId = null,
  }) {
    return _then(_value.copyWith(
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyGoalMinutes: null == dailyGoalMinutes
          ? _value.dailyGoalMinutes
          : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyGoalMinutes: null == weeklyGoalMinutes
          ? _value.weeklyGoalMinutes
          : weeklyGoalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      profiles: null == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<TimerProfile>,
      activeProfileId: null == activeProfileId
          ? _value.activeProfileId
          : activeProfileId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool notificationsEnabled,
      bool soundEnabled,
      bool vibrationEnabled,
      int dailyGoalMinutes,
      int weeklyGoalMinutes,
      List<TimerProfile> profiles,
      String activeProfileId});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationsEnabled = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? dailyGoalMinutes = null,
    Object? weeklyGoalMinutes = null,
    Object? profiles = null,
    Object? activeProfileId = null,
  }) {
    return _then(_$UserSettingsImpl(
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyGoalMinutes: null == dailyGoalMinutes
          ? _value.dailyGoalMinutes
          : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyGoalMinutes: null == weeklyGoalMinutes
          ? _value.weeklyGoalMinutes
          : weeklyGoalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      profiles: null == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<TimerProfile>,
      activeProfileId: null == activeProfileId
          ? _value.activeProfileId
          : activeProfileId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserSettingsImpl extends _UserSettings {
  const _$UserSettingsImpl(
      {this.notificationsEnabled = true,
      this.soundEnabled = true,
      this.vibrationEnabled = true,
      this.dailyGoalMinutes = 100,
      this.weeklyGoalMinutes = 500,
      final List<TimerProfile> profiles = const [],
      this.activeProfileId = 'default_pomodoro'})
      : _profiles = profiles,
        super._();

  /// Whether push notifications are enabled
  @override
  @JsonKey()
  final bool notificationsEnabled;

  /// Whether sounds are enabled
  @override
  @JsonKey()
  final bool soundEnabled;

  /// Whether vibration feedback is enabled
  @override
  @JsonKey()
  final bool vibrationEnabled;

  /// Daily focus goal in minutes (default: 100 = 25 * 4)
  @override
  @JsonKey()
  final int dailyGoalMinutes;

  /// Weekly focus goal in minutes (default: 500 = 25 * 20)
  @override
  @JsonKey()
  final int weeklyGoalMinutes;

  /// List of available timer profiles
  final List<TimerProfile> _profiles;

  /// List of available timer profiles
  @override
  @JsonKey()
  List<TimerProfile> get profiles {
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profiles);
  }

  /// ID of the currently active timer profile
  @override
  @JsonKey()
  final String activeProfileId;

  @override
  String toString() {
    return 'UserSettings(notificationsEnabled: $notificationsEnabled, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, dailyGoalMinutes: $dailyGoalMinutes, weeklyGoalMinutes: $weeklyGoalMinutes, profiles: $profiles, activeProfileId: $activeProfileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            (identical(other.dailyGoalMinutes, dailyGoalMinutes) ||
                other.dailyGoalMinutes == dailyGoalMinutes) &&
            (identical(other.weeklyGoalMinutes, weeklyGoalMinutes) ||
                other.weeklyGoalMinutes == weeklyGoalMinutes) &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            (identical(other.activeProfileId, activeProfileId) ||
                other.activeProfileId == activeProfileId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      notificationsEnabled,
      soundEnabled,
      vibrationEnabled,
      dailyGoalMinutes,
      weeklyGoalMinutes,
      const DeepCollectionEquality().hash(_profiles),
      activeProfileId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);
}

abstract class _UserSettings extends UserSettings {
  const factory _UserSettings(
      {final bool notificationsEnabled,
      final bool soundEnabled,
      final bool vibrationEnabled,
      final int dailyGoalMinutes,
      final int weeklyGoalMinutes,
      final List<TimerProfile> profiles,
      final String activeProfileId}) = _$UserSettingsImpl;
  const _UserSettings._() : super._();

  @override

  /// Whether push notifications are enabled
  bool get notificationsEnabled;
  @override

  /// Whether sounds are enabled
  bool get soundEnabled;
  @override

  /// Whether vibration feedback is enabled
  bool get vibrationEnabled;
  @override

  /// Daily focus goal in minutes (default: 100 = 25 * 4)
  int get dailyGoalMinutes;
  @override

  /// Weekly focus goal in minutes (default: 500 = 25 * 20)
  int get weeklyGoalMinutes;
  @override

  /// List of available timer profiles
  List<TimerProfile> get profiles;
  @override

  /// ID of the currently active timer profile
  String get activeProfileId;
  @override
  @JsonKey(ignore: true)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
