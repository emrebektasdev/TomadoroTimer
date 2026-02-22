// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) cache,
    required TResult Function(String message, String field) validation,
    required TResult Function(String message, Object? originalError) unexpected,
    required TResult Function(String entityName, String? id) notFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? cache,
    TResult? Function(String message, String field)? validation,
    TResult? Function(String message, Object? originalError)? unexpected,
    TResult? Function(String entityName, String? id)? notFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? cache,
    TResult Function(String message, String field)? validation,
    TResult Function(String message, Object? originalError)? unexpected,
    TResult Function(String entityName, String? id)? notFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CacheFailure value) cache,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(NotFoundFailure value) notFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(NotFoundFailure value)? notFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CacheFailure value)? cache,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(NotFoundFailure value)? notFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
          _$CacheFailureImpl value, $Res Function(_$CacheFailureImpl) then) =
      __$$CacheFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
      _$CacheFailureImpl _value, $Res Function(_$CacheFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_$CacheFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
    ));
  }
}

/// @nodoc

class _$CacheFailureImpl extends CacheFailure {
  const _$CacheFailureImpl({required this.message, this.originalError})
      : super._();

  @override
  final String message;
  @override
  final Object? originalError;

  @override
  String toString() {
    return 'Failure.cache(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) cache,
    required TResult Function(String message, String field) validation,
    required TResult Function(String message, Object? originalError) unexpected,
    required TResult Function(String entityName, String? id) notFound,
  }) {
    return cache(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? cache,
    TResult? Function(String message, String field)? validation,
    TResult? Function(String message, Object? originalError)? unexpected,
    TResult? Function(String entityName, String? id)? notFound,
  }) {
    return cache?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? cache,
    TResult Function(String message, String field)? validation,
    TResult Function(String message, Object? originalError)? unexpected,
    TResult Function(String entityName, String? id)? notFound,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CacheFailure value) cache,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(NotFoundFailure value) notFound,
  }) {
    return cache(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(NotFoundFailure value)? notFound,
  }) {
    return cache?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CacheFailure value)? cache,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(NotFoundFailure value)? notFound,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(this);
    }
    return orElse();
  }
}

abstract class CacheFailure extends Failure {
  const factory CacheFailure(
      {required final String message,
      final Object? originalError}) = _$CacheFailureImpl;
  const CacheFailure._() : super._();

  String get message;
  Object? get originalError;
  @JsonKey(ignore: true)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(_$ValidationFailureImpl value,
          $Res Function(_$ValidationFailureImpl) then) =
      __$$ValidationFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String field});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(_$ValidationFailureImpl _value,
      $Res Function(_$ValidationFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? field = null,
  }) {
    return _then(_$ValidationFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ValidationFailureImpl extends ValidationFailure {
  const _$ValidationFailureImpl({required this.message, required this.field})
      : super._();

  @override
  final String message;
  @override
  final String field;

  @override
  String toString() {
    return 'Failure.validation(message: $message, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, field);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) cache,
    required TResult Function(String message, String field) validation,
    required TResult Function(String message, Object? originalError) unexpected,
    required TResult Function(String entityName, String? id) notFound,
  }) {
    return validation(message, field);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? cache,
    TResult? Function(String message, String field)? validation,
    TResult? Function(String message, Object? originalError)? unexpected,
    TResult? Function(String entityName, String? id)? notFound,
  }) {
    return validation?.call(message, field);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? cache,
    TResult Function(String message, String field)? validation,
    TResult Function(String message, Object? originalError)? unexpected,
    TResult Function(String entityName, String? id)? notFound,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message, field);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CacheFailure value) cache,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(NotFoundFailure value) notFound,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(NotFoundFailure value)? notFound,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CacheFailure value)? cache,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(NotFoundFailure value)? notFound,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure extends Failure {
  const factory ValidationFailure(
      {required final String message,
      required final String field}) = _$ValidationFailureImpl;
  const ValidationFailure._() : super._();

  String get message;
  String get field;
  @JsonKey(ignore: true)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(_$UnexpectedFailureImpl value,
          $Res Function(_$UnexpectedFailureImpl) then) =
      __$$UnexpectedFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(_$UnexpectedFailureImpl _value,
      $Res Function(_$UnexpectedFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_$UnexpectedFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
    ));
  }
}

/// @nodoc

class _$UnexpectedFailureImpl extends UnexpectedFailure {
  const _$UnexpectedFailureImpl({required this.message, this.originalError})
      : super._();

  @override
  final String message;
  @override
  final Object? originalError;

  @override
  String toString() {
    return 'Failure.unexpected(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      __$$UnexpectedFailureImplCopyWithImpl<_$UnexpectedFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) cache,
    required TResult Function(String message, String field) validation,
    required TResult Function(String message, Object? originalError) unexpected,
    required TResult Function(String entityName, String? id) notFound,
  }) {
    return unexpected(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? cache,
    TResult? Function(String message, String field)? validation,
    TResult? Function(String message, Object? originalError)? unexpected,
    TResult? Function(String entityName, String? id)? notFound,
  }) {
    return unexpected?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? cache,
    TResult Function(String message, String field)? validation,
    TResult Function(String message, Object? originalError)? unexpected,
    TResult Function(String entityName, String? id)? notFound,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CacheFailure value) cache,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(NotFoundFailure value) notFound,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(NotFoundFailure value)? notFound,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CacheFailure value)? cache,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(NotFoundFailure value)? notFound,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class UnexpectedFailure extends Failure {
  const factory UnexpectedFailure(
      {required final String message,
      final Object? originalError}) = _$UnexpectedFailureImpl;
  const UnexpectedFailure._() : super._();

  String get message;
  Object? get originalError;
  @JsonKey(ignore: true)
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(_$NotFoundFailureImpl value,
          $Res Function(_$NotFoundFailureImpl) then) =
      __$$NotFoundFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String entityName, String? id});
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
      _$NotFoundFailureImpl _value, $Res Function(_$NotFoundFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityName = null,
    Object? id = freezed,
  }) {
    return _then(_$NotFoundFailureImpl(
      entityName: null == entityName
          ? _value.entityName
          : entityName // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotFoundFailureImpl extends NotFoundFailure {
  const _$NotFoundFailureImpl({required this.entityName, this.id}) : super._();

  @override
  final String entityName;
  @override
  final String? id;

  @override
  String toString() {
    return 'Failure.notFound(entityName: $entityName, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundFailureImpl &&
            (identical(other.entityName, entityName) ||
                other.entityName == entityName) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entityName, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      __$$NotFoundFailureImplCopyWithImpl<_$NotFoundFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, Object? originalError) cache,
    required TResult Function(String message, String field) validation,
    required TResult Function(String message, Object? originalError) unexpected,
    required TResult Function(String entityName, String? id) notFound,
  }) {
    return notFound(entityName, id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? originalError)? cache,
    TResult? Function(String message, String field)? validation,
    TResult? Function(String message, Object? originalError)? unexpected,
    TResult? Function(String entityName, String? id)? notFound,
  }) {
    return notFound?.call(entityName, id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? originalError)? cache,
    TResult Function(String message, String field)? validation,
    TResult Function(String message, Object? originalError)? unexpected,
    TResult Function(String entityName, String? id)? notFound,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(entityName, id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CacheFailure value) cache,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(UnexpectedFailure value) unexpected,
    required TResult Function(NotFoundFailure value) notFound,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(UnexpectedFailure value)? unexpected,
    TResult? Function(NotFoundFailure value)? notFound,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CacheFailure value)? cache,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(UnexpectedFailure value)? unexpected,
    TResult Function(NotFoundFailure value)? notFound,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundFailure extends Failure {
  const factory NotFoundFailure(
      {required final String entityName,
      final String? id}) = _$NotFoundFailureImpl;
  const NotFoundFailure._() : super._();

  String get entityName;
  String? get id;
  @JsonKey(ignore: true)
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
