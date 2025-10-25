// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LevelState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelStateCopyWith<$Res> {
  factory $LevelStateCopyWith(
          LevelState value, $Res Function(LevelState) then) =
      _$LevelStateCopyWithImpl<$Res, LevelState>;
}

/// @nodoc
class _$LevelStateCopyWithImpl<$Res, $Val extends LevelState>
    implements $LevelStateCopyWith<$Res> {
  _$LevelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LevelInitialImplCopyWith<$Res> {
  factory _$$LevelInitialImplCopyWith(
          _$LevelInitialImpl value, $Res Function(_$LevelInitialImpl) then) =
      __$$LevelInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LevelInitialImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelInitialImpl>
    implements _$$LevelInitialImplCopyWith<$Res> {
  __$$LevelInitialImplCopyWithImpl(
      _$LevelInitialImpl _value, $Res Function(_$LevelInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LevelInitialImpl implements LevelInitial {
  const _$LevelInitialImpl();

  @override
  String toString() {
    return 'LevelState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LevelInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class LevelInitial implements LevelState {
  const factory LevelInitial() = _$LevelInitialImpl;
}

/// @nodoc
abstract class _$$LevelSelectionMadeImplCopyWith<$Res> {
  factory _$$LevelSelectionMadeImplCopyWith(_$LevelSelectionMadeImpl value,
          $Res Function(_$LevelSelectionMadeImpl) then) =
      __$$LevelSelectionMadeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Level level});
}

/// @nodoc
class __$$LevelSelectionMadeImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelSelectionMadeImpl>
    implements _$$LevelSelectionMadeImplCopyWith<$Res> {
  __$$LevelSelectionMadeImplCopyWithImpl(_$LevelSelectionMadeImpl _value,
      $Res Function(_$LevelSelectionMadeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
  }) {
    return _then(_$LevelSelectionMadeImpl(
      null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
    ));
  }
}

/// @nodoc

class _$LevelSelectionMadeImpl implements LevelSelectionMade {
  const _$LevelSelectionMadeImpl(this.level);

  @override
  final Level level;

  @override
  String toString() {
    return 'LevelState.selectionMade(level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelSelectionMadeImpl &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelSelectionMadeImplCopyWith<_$LevelSelectionMadeImpl> get copyWith =>
      __$$LevelSelectionMadeImplCopyWithImpl<_$LevelSelectionMadeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) {
    return selectionMade(level);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) {
    return selectionMade?.call(level);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) {
    if (selectionMade != null) {
      return selectionMade(level);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) {
    return selectionMade(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) {
    return selectionMade?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) {
    if (selectionMade != null) {
      return selectionMade(this);
    }
    return orElse();
  }
}

abstract class LevelSelectionMade implements LevelState {
  const factory LevelSelectionMade(final Level level) =
      _$LevelSelectionMadeImpl;

  Level get level;
  @JsonKey(ignore: true)
  _$$LevelSelectionMadeImplCopyWith<_$LevelSelectionMadeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelLoadingImplCopyWith<$Res> {
  factory _$$LevelLoadingImplCopyWith(
          _$LevelLoadingImpl value, $Res Function(_$LevelLoadingImpl) then) =
      __$$LevelLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Level level});
}

/// @nodoc
class __$$LevelLoadingImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelLoadingImpl>
    implements _$$LevelLoadingImplCopyWith<$Res> {
  __$$LevelLoadingImplCopyWithImpl(
      _$LevelLoadingImpl _value, $Res Function(_$LevelLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
  }) {
    return _then(_$LevelLoadingImpl(
      null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
    ));
  }
}

/// @nodoc

class _$LevelLoadingImpl implements LevelLoading {
  const _$LevelLoadingImpl(this.level);

  @override
  final Level level;

  @override
  String toString() {
    return 'LevelState.loading(level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelLoadingImpl &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelLoadingImplCopyWith<_$LevelLoadingImpl> get copyWith =>
      __$$LevelLoadingImplCopyWithImpl<_$LevelLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) {
    return loading(level);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) {
    return loading?.call(level);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(level);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LevelLoading implements LevelState {
  const factory LevelLoading(final Level level) = _$LevelLoadingImpl;

  Level get level;
  @JsonKey(ignore: true)
  _$$LevelLoadingImplCopyWith<_$LevelLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelSuccessImplCopyWith<$Res> {
  factory _$$LevelSuccessImplCopyWith(
          _$LevelSuccessImpl value, $Res Function(_$LevelSuccessImpl) then) =
      __$$LevelSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Level level});
}

/// @nodoc
class __$$LevelSuccessImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelSuccessImpl>
    implements _$$LevelSuccessImplCopyWith<$Res> {
  __$$LevelSuccessImplCopyWithImpl(
      _$LevelSuccessImpl _value, $Res Function(_$LevelSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
  }) {
    return _then(_$LevelSuccessImpl(
      null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
    ));
  }
}

/// @nodoc

class _$LevelSuccessImpl implements LevelSuccess {
  const _$LevelSuccessImpl(this.level);

  @override
  final Level level;

  @override
  String toString() {
    return 'LevelState.success(level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelSuccessImpl &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelSuccessImplCopyWith<_$LevelSuccessImpl> get copyWith =>
      __$$LevelSuccessImplCopyWithImpl<_$LevelSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) {
    return success(level);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) {
    return success?.call(level);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(level);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class LevelSuccess implements LevelState {
  const factory LevelSuccess(final Level level) = _$LevelSuccessImpl;

  Level get level;
  @JsonKey(ignore: true)
  _$$LevelSuccessImplCopyWith<_$LevelSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelErrorImplCopyWith<$Res> {
  factory _$$LevelErrorImplCopyWith(
          _$LevelErrorImpl value, $Res Function(_$LevelErrorImpl) then) =
      __$$LevelErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Level? level});
}

/// @nodoc
class __$$LevelErrorImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelErrorImpl>
    implements _$$LevelErrorImplCopyWith<$Res> {
  __$$LevelErrorImplCopyWithImpl(
      _$LevelErrorImpl _value, $Res Function(_$LevelErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? level = freezed,
  }) {
    return _then(_$LevelErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level?,
    ));
  }
}

/// @nodoc

class _$LevelErrorImpl implements LevelError {
  const _$LevelErrorImpl(this.message, this.level);

  @override
  final String message;
  @override
  final Level? level;

  @override
  String toString() {
    return 'LevelState.error(message: $message, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelErrorImplCopyWith<_$LevelErrorImpl> get copyWith =>
      __$$LevelErrorImplCopyWithImpl<_$LevelErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Level level) selectionMade,
    required TResult Function(Level level) loading,
    required TResult Function(Level level) success,
    required TResult Function(String message, Level? level) error,
  }) {
    return error(message, level);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Level level)? selectionMade,
    TResult? Function(Level level)? loading,
    TResult? Function(Level level)? success,
    TResult? Function(String message, Level? level)? error,
  }) {
    return error?.call(message, level);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Level level)? selectionMade,
    TResult Function(Level level)? loading,
    TResult Function(Level level)? success,
    TResult Function(String message, Level? level)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, level);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelInitial value) initial,
    required TResult Function(LevelSelectionMade value) selectionMade,
    required TResult Function(LevelLoading value) loading,
    required TResult Function(LevelSuccess value) success,
    required TResult Function(LevelError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelInitial value)? initial,
    TResult? Function(LevelSelectionMade value)? selectionMade,
    TResult? Function(LevelLoading value)? loading,
    TResult? Function(LevelSuccess value)? success,
    TResult? Function(LevelError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelInitial value)? initial,
    TResult Function(LevelSelectionMade value)? selectionMade,
    TResult Function(LevelLoading value)? loading,
    TResult Function(LevelSuccess value)? success,
    TResult Function(LevelError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LevelError implements LevelState {
  const factory LevelError(final String message, final Level? level) =
      _$LevelErrorImpl;

  String get message;
  Level? get level;
  @JsonKey(ignore: true)
  _$$LevelErrorImplCopyWith<_$LevelErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
