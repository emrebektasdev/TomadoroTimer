// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipped_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EquippedItems {
  /// Currently equipped accessory ID (e.g., 'acc_sunglasses')
  String? get accessoryId => throw _privateConstructorUsedError;

  /// Currently equipped background ID (e.g., 'bg_sunset')
  String? get backgroundId => throw _privateConstructorUsedError;

  /// Currently equipped sound ID (e.g., 'sound_rain')
  String? get soundId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EquippedItemsCopyWith<EquippedItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquippedItemsCopyWith<$Res> {
  factory $EquippedItemsCopyWith(
          EquippedItems value, $Res Function(EquippedItems) then) =
      _$EquippedItemsCopyWithImpl<$Res, EquippedItems>;
  @useResult
  $Res call({String? accessoryId, String? backgroundId, String? soundId});
}

/// @nodoc
class _$EquippedItemsCopyWithImpl<$Res, $Val extends EquippedItems>
    implements $EquippedItemsCopyWith<$Res> {
  _$EquippedItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessoryId = freezed,
    Object? backgroundId = freezed,
    Object? soundId = freezed,
  }) {
    return _then(_value.copyWith(
      accessoryId: freezed == accessoryId
          ? _value.accessoryId
          : accessoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundId: freezed == backgroundId
          ? _value.backgroundId
          : backgroundId // ignore: cast_nullable_to_non_nullable
              as String?,
      soundId: freezed == soundId
          ? _value.soundId
          : soundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquippedItemsImplCopyWith<$Res>
    implements $EquippedItemsCopyWith<$Res> {
  factory _$$EquippedItemsImplCopyWith(
          _$EquippedItemsImpl value, $Res Function(_$EquippedItemsImpl) then) =
      __$$EquippedItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? accessoryId, String? backgroundId, String? soundId});
}

/// @nodoc
class __$$EquippedItemsImplCopyWithImpl<$Res>
    extends _$EquippedItemsCopyWithImpl<$Res, _$EquippedItemsImpl>
    implements _$$EquippedItemsImplCopyWith<$Res> {
  __$$EquippedItemsImplCopyWithImpl(
      _$EquippedItemsImpl _value, $Res Function(_$EquippedItemsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessoryId = freezed,
    Object? backgroundId = freezed,
    Object? soundId = freezed,
  }) {
    return _then(_$EquippedItemsImpl(
      accessoryId: freezed == accessoryId
          ? _value.accessoryId
          : accessoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundId: freezed == backgroundId
          ? _value.backgroundId
          : backgroundId // ignore: cast_nullable_to_non_nullable
              as String?,
      soundId: freezed == soundId
          ? _value.soundId
          : soundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EquippedItemsImpl extends _EquippedItems {
  const _$EquippedItemsImpl({this.accessoryId, this.backgroundId, this.soundId})
      : super._();

  /// Currently equipped accessory ID (e.g., 'acc_sunglasses')
  @override
  final String? accessoryId;

  /// Currently equipped background ID (e.g., 'bg_sunset')
  @override
  final String? backgroundId;

  /// Currently equipped sound ID (e.g., 'sound_rain')
  @override
  final String? soundId;

  @override
  String toString() {
    return 'EquippedItems(accessoryId: $accessoryId, backgroundId: $backgroundId, soundId: $soundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquippedItemsImpl &&
            (identical(other.accessoryId, accessoryId) ||
                other.accessoryId == accessoryId) &&
            (identical(other.backgroundId, backgroundId) ||
                other.backgroundId == backgroundId) &&
            (identical(other.soundId, soundId) || other.soundId == soundId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accessoryId, backgroundId, soundId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquippedItemsImplCopyWith<_$EquippedItemsImpl> get copyWith =>
      __$$EquippedItemsImplCopyWithImpl<_$EquippedItemsImpl>(this, _$identity);
}

abstract class _EquippedItems extends EquippedItems {
  const factory _EquippedItems(
      {final String? accessoryId,
      final String? backgroundId,
      final String? soundId}) = _$EquippedItemsImpl;
  const _EquippedItems._() : super._();

  @override

  /// Currently equipped accessory ID (e.g., 'acc_sunglasses')
  String? get accessoryId;
  @override

  /// Currently equipped background ID (e.g., 'bg_sunset')
  String? get backgroundId;
  @override

  /// Currently equipped sound ID (e.g., 'sound_rain')
  String? get soundId;
  @override
  @JsonKey(ignore: true)
  _$$EquippedItemsImplCopyWith<_$EquippedItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
