// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserState {
  /// User profile data (balance, stats, streak)
  UserProfile get profile => throw _privateConstructorUsedError;

  /// User settings/preferences
  UserSettings get settings => throw _privateConstructorUsedError;

  /// Currently equipped cosmetic items
  EquippedItems get equippedItems => throw _privateConstructorUsedError;

  /// List of purchased item IDs
  List<String> get purchasedItemIds => throw _privateConstructorUsedError;

  /// Whether the state is currently loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message if something went wrong
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserStateCopyWith<UserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
  @useResult
  $Res call(
      {UserProfile profile,
      UserSettings settings,
      EquippedItems equippedItems,
      List<String> purchasedItemIds,
      bool isLoading,
      String? errorMessage});

  $UserProfileCopyWith<$Res> get profile;
  $UserSettingsCopyWith<$Res> get settings;
  $EquippedItemsCopyWith<$Res> get equippedItems;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? settings = null,
    Object? equippedItems = null,
    Object? purchasedItemIds = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as UserSettings,
      equippedItems: null == equippedItems
          ? _value.equippedItems
          : equippedItems // ignore: cast_nullable_to_non_nullable
              as EquippedItems,
      purchasedItemIds: null == purchasedItemIds
          ? _value.purchasedItemIds
          : purchasedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get profile {
    return $UserProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSettingsCopyWith<$Res> get settings {
    return $UserSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EquippedItemsCopyWith<$Res> get equippedItems {
    return $EquippedItemsCopyWith<$Res>(_value.equippedItems, (value) {
      return _then(_value.copyWith(equippedItems: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserStateImplCopyWith<$Res>
    implements $UserStateCopyWith<$Res> {
  factory _$$UserStateImplCopyWith(
          _$UserStateImpl value, $Res Function(_$UserStateImpl) then) =
      __$$UserStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserProfile profile,
      UserSettings settings,
      EquippedItems equippedItems,
      List<String> purchasedItemIds,
      bool isLoading,
      String? errorMessage});

  @override
  $UserProfileCopyWith<$Res> get profile;
  @override
  $UserSettingsCopyWith<$Res> get settings;
  @override
  $EquippedItemsCopyWith<$Res> get equippedItems;
}

/// @nodoc
class __$$UserStateImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateImpl>
    implements _$$UserStateImplCopyWith<$Res> {
  __$$UserStateImplCopyWithImpl(
      _$UserStateImpl _value, $Res Function(_$UserStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? settings = null,
    Object? equippedItems = null,
    Object? purchasedItemIds = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$UserStateImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as UserSettings,
      equippedItems: null == equippedItems
          ? _value.equippedItems
          : equippedItems // ignore: cast_nullable_to_non_nullable
              as EquippedItems,
      purchasedItemIds: null == purchasedItemIds
          ? _value._purchasedItemIds
          : purchasedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserStateImpl extends _UserState {
  const _$UserStateImpl(
      {required this.profile,
      required this.settings,
      required this.equippedItems,
      required final List<String> purchasedItemIds,
      this.isLoading = false,
      this.errorMessage})
      : _purchasedItemIds = purchasedItemIds,
        super._();

  /// User profile data (balance, stats, streak)
  @override
  final UserProfile profile;

  /// User settings/preferences
  @override
  final UserSettings settings;

  /// Currently equipped cosmetic items
  @override
  final EquippedItems equippedItems;

  /// List of purchased item IDs
  final List<String> _purchasedItemIds;

  /// List of purchased item IDs
  @override
  List<String> get purchasedItemIds {
    if (_purchasedItemIds is EqualUnmodifiableListView)
      return _purchasedItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasedItemIds);
  }

  /// Whether the state is currently loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message if something went wrong
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'UserState(profile: $profile, settings: $settings, equippedItems: $equippedItems, purchasedItemIds: $purchasedItemIds, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.equippedItems, equippedItems) ||
                other.equippedItems == equippedItems) &&
            const DeepCollectionEquality()
                .equals(other._purchasedItemIds, _purchasedItemIds) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      profile,
      settings,
      equippedItems,
      const DeepCollectionEquality().hash(_purchasedItemIds),
      isLoading,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStateImplCopyWith<_$UserStateImpl> get copyWith =>
      __$$UserStateImplCopyWithImpl<_$UserStateImpl>(this, _$identity);
}

abstract class _UserState extends UserState {
  const factory _UserState(
      {required final UserProfile profile,
      required final UserSettings settings,
      required final EquippedItems equippedItems,
      required final List<String> purchasedItemIds,
      final bool isLoading,
      final String? errorMessage}) = _$UserStateImpl;
  const _UserState._() : super._();

  @override

  /// User profile data (balance, stats, streak)
  UserProfile get profile;
  @override

  /// User settings/preferences
  UserSettings get settings;
  @override

  /// Currently equipped cosmetic items
  EquippedItems get equippedItems;
  @override

  /// List of purchased item IDs
  List<String> get purchasedItemIds;
  @override

  /// Whether the state is currently loading
  bool get isLoading;
  @override

  /// Error message if something went wrong
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$UserStateImplCopyWith<_$UserStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
