// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LevelEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level) levelSelected,
    required TResult Function() levelSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level)? levelSelected,
    TResult? Function()? levelSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level)? levelSelected,
    TResult Function()? levelSubmitted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelSelected value) levelSelected,
    required TResult Function(LevelSubmitted value) levelSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelSelected value)? levelSelected,
    TResult? Function(LevelSubmitted value)? levelSubmitted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelSelected value)? levelSelected,
    TResult Function(LevelSubmitted value)? levelSubmitted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelEventCopyWith<$Res> {
  factory $LevelEventCopyWith(
          LevelEvent value, $Res Function(LevelEvent) then) =
      _$LevelEventCopyWithImpl<$Res, LevelEvent>;
}

/// @nodoc
class _$LevelEventCopyWithImpl<$Res, $Val extends LevelEvent>
    implements $LevelEventCopyWith<$Res> {
  _$LevelEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LevelEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LevelSelectedImplCopyWith<$Res> {
  factory _$$LevelSelectedImplCopyWith(
          _$LevelSelectedImpl value, $Res Function(_$LevelSelectedImpl) then) =
      __$$LevelSelectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Level level});
}

/// @nodoc
class __$$LevelSelectedImplCopyWithImpl<$Res>
    extends _$LevelEventCopyWithImpl<$Res, _$LevelSelectedImpl>
    implements _$$LevelSelectedImplCopyWith<$Res> {
  __$$LevelSelectedImplCopyWithImpl(
      _$LevelSelectedImpl _value, $Res Function(_$LevelSelectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LevelEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
  }) {
    return _then(_$LevelSelectedImpl(
      null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
    ));
  }
}

/// @nodoc

class _$LevelSelectedImpl implements LevelSelected {
  const _$LevelSelectedImpl(this.level);

  @override
  final Level level;

  @override
  String toString() {
    return 'LevelEvent.levelSelected(level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelSelectedImpl &&
            (identical(other.level, level) || other.level == level));
  }

  @override
  int get hashCode => Object.hash(runtimeType, level);

  /// Create a copy of LevelEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelSelectedImplCopyWith<_$LevelSelectedImpl> get copyWith =>
      __$$LevelSelectedImplCopyWithImpl<_$LevelSelectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level) levelSelected,
    required TResult Function() levelSubmitted,
  }) {
    return levelSelected(level);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level)? levelSelected,
    TResult? Function()? levelSubmitted,
  }) {
    return levelSelected?.call(level);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level)? levelSelected,
    TResult Function()? levelSubmitted,
    required TResult orElse(),
  }) {
    if (levelSelected != null) {
      return levelSelected(level);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelSelected value) levelSelected,
    required TResult Function(LevelSubmitted value) levelSubmitted,
  }) {
    return levelSelected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelSelected value)? levelSelected,
    TResult? Function(LevelSubmitted value)? levelSubmitted,
  }) {
    return levelSelected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelSelected value)? levelSelected,
    TResult Function(LevelSubmitted value)? levelSubmitted,
    required TResult orElse(),
  }) {
    if (levelSelected != null) {
      return levelSelected(this);
    }
    return orElse();
  }
}

abstract class LevelSelected implements LevelEvent {
  const factory LevelSelected(final Level level) = _$LevelSelectedImpl;

  Level get level;

  /// Create a copy of LevelEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelSelectedImplCopyWith<_$LevelSelectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelSubmittedImplCopyWith<$Res> {
  factory _$$LevelSubmittedImplCopyWith(_$LevelSubmittedImpl value,
          $Res Function(_$LevelSubmittedImpl) then) =
      __$$LevelSubmittedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LevelSubmittedImplCopyWithImpl<$Res>
    extends _$LevelEventCopyWithImpl<$Res, _$LevelSubmittedImpl>
    implements _$$LevelSubmittedImplCopyWith<$Res> {
  __$$LevelSubmittedImplCopyWithImpl(
      _$LevelSubmittedImpl _value, $Res Function(_$LevelSubmittedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LevelEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LevelSubmittedImpl implements LevelSubmitted {
  const _$LevelSubmittedImpl();

  @override
  String toString() {
    return 'LevelEvent.levelSubmitted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LevelSubmittedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level) levelSelected,
    required TResult Function() levelSubmitted,
  }) {
    return levelSubmitted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level)? levelSelected,
    TResult? Function()? levelSubmitted,
  }) {
    return levelSubmitted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level)? levelSelected,
    TResult Function()? levelSubmitted,
    required TResult orElse(),
  }) {
    if (levelSubmitted != null) {
      return levelSubmitted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LevelSelected value) levelSelected,
    required TResult Function(LevelSubmitted value) levelSubmitted,
  }) {
    return levelSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LevelSelected value)? levelSelected,
    TResult? Function(LevelSubmitted value)? levelSubmitted,
  }) {
    return levelSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LevelSelected value)? levelSelected,
    TResult Function(LevelSubmitted value)? levelSubmitted,
    required TResult orElse(),
  }) {
    if (levelSubmitted != null) {
      return levelSubmitted(this);
    }
    return orElse();
  }
}

abstract class LevelSubmitted implements LevelEvent {
  const factory LevelSubmitted() = _$LevelSubmittedImpl;
}
