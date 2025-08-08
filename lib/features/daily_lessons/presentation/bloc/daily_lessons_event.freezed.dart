// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_lessons_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyLessonsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchLessons,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(RefreshLessons value)? refreshLessons,
    TResult Function(GetUserPreferences value)? getUserPreferences,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLessonsEventCopyWith<$Res> {
  factory $DailyLessonsEventCopyWith(
          DailyLessonsEvent value, $Res Function(DailyLessonsEvent) then) =
      _$DailyLessonsEventCopyWithImpl<$Res, DailyLessonsEvent>;
}

/// @nodoc
class _$DailyLessonsEventCopyWithImpl<$Res, $Val extends DailyLessonsEvent>
    implements $DailyLessonsEventCopyWith<$Res> {
  _$DailyLessonsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyLessonsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchLessonsImplCopyWith<$Res> {
  factory _$$FetchLessonsImplCopyWith(
          _$FetchLessonsImpl value, $Res Function(_$FetchLessonsImpl) then) =
      __$$FetchLessonsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchLessonsImplCopyWithImpl<$Res>
    extends _$DailyLessonsEventCopyWithImpl<$Res, _$FetchLessonsImpl>
    implements _$$FetchLessonsImplCopyWith<$Res> {
  __$$FetchLessonsImplCopyWithImpl(
      _$FetchLessonsImpl _value, $Res Function(_$FetchLessonsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyLessonsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchLessonsImpl implements FetchLessons {
  const _$FetchLessonsImpl();

  @override
  String toString() {
    return 'DailyLessonsEvent.fetchLessons()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchLessonsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchLessons,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return fetchLessons();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return fetchLessons?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) {
    if (fetchLessons != null) {
      return fetchLessons();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return fetchLessons(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return fetchLessons?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(RefreshLessons value)? refreshLessons,
    TResult Function(GetUserPreferences value)? getUserPreferences,
    required TResult orElse(),
  }) {
    if (fetchLessons != null) {
      return fetchLessons(this);
    }
    return orElse();
  }
}

abstract class FetchLessons implements DailyLessonsEvent {
  const factory FetchLessons() = _$FetchLessonsImpl;
}

/// @nodoc
abstract class _$$RefreshLessonsImplCopyWith<$Res> {
  factory _$$RefreshLessonsImplCopyWith(_$RefreshLessonsImpl value,
          $Res Function(_$RefreshLessonsImpl) then) =
      __$$RefreshLessonsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshLessonsImplCopyWithImpl<$Res>
    extends _$DailyLessonsEventCopyWithImpl<$Res, _$RefreshLessonsImpl>
    implements _$$RefreshLessonsImplCopyWith<$Res> {
  __$$RefreshLessonsImplCopyWithImpl(
      _$RefreshLessonsImpl _value, $Res Function(_$RefreshLessonsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyLessonsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshLessonsImpl implements RefreshLessons {
  const _$RefreshLessonsImpl();

  @override
  String toString() {
    return 'DailyLessonsEvent.refreshLessons()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshLessonsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchLessons,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return refreshLessons();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return refreshLessons?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) {
    if (refreshLessons != null) {
      return refreshLessons();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return refreshLessons(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return refreshLessons?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(RefreshLessons value)? refreshLessons,
    TResult Function(GetUserPreferences value)? getUserPreferences,
    required TResult orElse(),
  }) {
    if (refreshLessons != null) {
      return refreshLessons(this);
    }
    return orElse();
  }
}

abstract class RefreshLessons implements DailyLessonsEvent {
  const factory RefreshLessons() = _$RefreshLessonsImpl;
}

/// @nodoc
abstract class _$$GetUserPreferencesImplCopyWith<$Res> {
  factory _$$GetUserPreferencesImplCopyWith(_$GetUserPreferencesImpl value,
          $Res Function(_$GetUserPreferencesImpl) then) =
      __$$GetUserPreferencesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetUserPreferencesImplCopyWithImpl<$Res>
    extends _$DailyLessonsEventCopyWithImpl<$Res, _$GetUserPreferencesImpl>
    implements _$$GetUserPreferencesImplCopyWith<$Res> {
  __$$GetUserPreferencesImplCopyWithImpl(_$GetUserPreferencesImpl _value,
      $Res Function(_$GetUserPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyLessonsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetUserPreferencesImpl implements GetUserPreferences {
  const _$GetUserPreferencesImpl();

  @override
  String toString() {
    return 'DailyLessonsEvent.getUserPreferences()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetUserPreferencesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchLessons,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return getUserPreferences();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return getUserPreferences?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) {
    if (getUserPreferences != null) {
      return getUserPreferences();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return getUserPreferences(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return getUserPreferences?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(RefreshLessons value)? refreshLessons,
    TResult Function(GetUserPreferences value)? getUserPreferences,
    required TResult orElse(),
  }) {
    if (getUserPreferences != null) {
      return getUserPreferences(this);
    }
    return orElse();
  }
}

abstract class GetUserPreferences implements DailyLessonsEvent {
  const factory GetUserPreferences() = _$GetUserPreferencesImpl;
}
