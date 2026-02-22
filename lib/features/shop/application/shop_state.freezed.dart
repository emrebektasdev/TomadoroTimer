// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShopState {
  /// All available shop items
  List<ShopItem> get allItems => throw _privateConstructorUsedError;

  /// Currently selected category
  ShopCategory get selectedCategory => throw _privateConstructorUsedError;

  /// Search query (if any)
  String get searchQuery => throw _privateConstructorUsedError;

  /// Whether items are loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message if something went wrong
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShopStateCopyWith<ShopState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopStateCopyWith<$Res> {
  factory $ShopStateCopyWith(ShopState value, $Res Function(ShopState) then) =
      _$ShopStateCopyWithImpl<$Res, ShopState>;
  @useResult
  $Res call(
      {List<ShopItem> allItems,
      ShopCategory selectedCategory,
      String searchQuery,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$ShopStateCopyWithImpl<$Res, $Val extends ShopState>
    implements $ShopStateCopyWith<$Res> {
  _$ShopStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allItems = null,
    Object? selectedCategory = null,
    Object? searchQuery = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      allItems: null == allItems
          ? _value.allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<ShopItem>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as ShopCategory,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
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
}

/// @nodoc
abstract class _$$ShopStateImplCopyWith<$Res>
    implements $ShopStateCopyWith<$Res> {
  factory _$$ShopStateImplCopyWith(
          _$ShopStateImpl value, $Res Function(_$ShopStateImpl) then) =
      __$$ShopStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ShopItem> allItems,
      ShopCategory selectedCategory,
      String searchQuery,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$ShopStateImplCopyWithImpl<$Res>
    extends _$ShopStateCopyWithImpl<$Res, _$ShopStateImpl>
    implements _$$ShopStateImplCopyWith<$Res> {
  __$$ShopStateImplCopyWithImpl(
      _$ShopStateImpl _value, $Res Function(_$ShopStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allItems = null,
    Object? selectedCategory = null,
    Object? searchQuery = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ShopStateImpl(
      allItems: null == allItems
          ? _value._allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<ShopItem>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as ShopCategory,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$ShopStateImpl extends _ShopState {
  const _$ShopStateImpl(
      {final List<ShopItem> allItems = const [],
      this.selectedCategory = ShopCategory.sounds,
      this.searchQuery = '',
      this.isLoading = false,
      this.errorMessage})
      : _allItems = allItems,
        super._();

  /// All available shop items
  final List<ShopItem> _allItems;

  /// All available shop items
  @override
  @JsonKey()
  List<ShopItem> get allItems {
    if (_allItems is EqualUnmodifiableListView) return _allItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItems);
  }

  /// Currently selected category
  @override
  @JsonKey()
  final ShopCategory selectedCategory;

  /// Search query (if any)
  @override
  @JsonKey()
  final String searchQuery;

  /// Whether items are loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message if something went wrong
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ShopState(allItems: $allItems, selectedCategory: $selectedCategory, searchQuery: $searchQuery, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopStateImpl &&
            const DeepCollectionEquality().equals(other._allItems, _allItems) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allItems),
      selectedCategory,
      searchQuery,
      isLoading,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopStateImplCopyWith<_$ShopStateImpl> get copyWith =>
      __$$ShopStateImplCopyWithImpl<_$ShopStateImpl>(this, _$identity);
}

abstract class _ShopState extends ShopState {
  const factory _ShopState(
      {final List<ShopItem> allItems,
      final ShopCategory selectedCategory,
      final String searchQuery,
      final bool isLoading,
      final String? errorMessage}) = _$ShopStateImpl;
  const _ShopState._() : super._();

  @override

  /// All available shop items
  List<ShopItem> get allItems;
  @override

  /// Currently selected category
  ShopCategory get selectedCategory;
  @override

  /// Search query (if any)
  String get searchQuery;
  @override

  /// Whether items are loading
  bool get isLoading;
  @override

  /// Error message if something went wrong
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ShopStateImplCopyWith<_$ShopStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
