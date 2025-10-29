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
    required TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)
        fetchLessonsWithCourseContext,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(FetchLessonsWithCourseContext value)
        fetchLessonsWithCourseContext,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
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
    required TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)
        fetchLessonsWithCourseContext,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return fetchLessons();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return fetchLessons?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
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
    required TResult Function(FetchLessonsWithCourseContext value)
        fetchLessonsWithCourseContext,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return fetchLessons(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return fetchLessons?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
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
abstract class _$$FetchLessonsWithCourseContextImplCopyWith<$Res> {
  factory _$$FetchLessonsWithCourseContextImplCopyWith(
          _$FetchLessonsWithCourseContextImpl value,
          $Res Function(_$FetchLessonsWithCourseContextImpl) then) =
      __$$FetchLessonsWithCourseContextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String pathId, int courseNumber, LearningPath learningPath});
}

/// @nodoc
class __$$FetchLessonsWithCourseContextImplCopyWithImpl<$Res>
    extends _$DailyLessonsEventCopyWithImpl<$Res,
        _$FetchLessonsWithCourseContextImpl>
    implements _$$FetchLessonsWithCourseContextImplCopyWith<$Res> {
  __$$FetchLessonsWithCourseContextImplCopyWithImpl(
      _$FetchLessonsWithCourseContextImpl _value,
      $Res Function(_$FetchLessonsWithCourseContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
    Object? courseNumber = null,
    Object? learningPath = null,
  }) {
    return _then(_$FetchLessonsWithCourseContextImpl(
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
      courseNumber: null == courseNumber
          ? _value.courseNumber
          : courseNumber // ignore: cast_nullable_to_non_nullable
              as int,
      learningPath: null == learningPath
          ? _value.learningPath
          : learningPath // ignore: cast_nullable_to_non_nullable
              as LearningPath,
    ));
  }
}

/// @nodoc

class _$FetchLessonsWithCourseContextImpl
    implements FetchLessonsWithCourseContext {
  const _$FetchLessonsWithCourseContextImpl(
      {required this.pathId,
      required this.courseNumber,
      required this.learningPath});

  @override
  final String pathId;
  @override
  final int courseNumber;
  @override
  final LearningPath learningPath;

  @override
  String toString() {
    return 'DailyLessonsEvent.fetchLessonsWithCourseContext(pathId: $pathId, courseNumber: $courseNumber, learningPath: $learningPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchLessonsWithCourseContextImpl &&
            (identical(other.pathId, pathId) || other.pathId == pathId) &&
            (identical(other.courseNumber, courseNumber) ||
                other.courseNumber == courseNumber) &&
            (identical(other.learningPath, learningPath) ||
                other.learningPath == learningPath));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pathId, courseNumber, learningPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchLessonsWithCourseContextImplCopyWith<
          _$FetchLessonsWithCourseContextImpl>
      get copyWith => __$$FetchLessonsWithCourseContextImplCopyWithImpl<
          _$FetchLessonsWithCourseContextImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchLessons,
    required TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)
        fetchLessonsWithCourseContext,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return fetchLessonsWithCourseContext(pathId, courseNumber, learningPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return fetchLessonsWithCourseContext?.call(
        pathId, courseNumber, learningPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult Function()? refreshLessons,
    TResult Function()? getUserPreferences,
    required TResult orElse(),
  }) {
    if (fetchLessonsWithCourseContext != null) {
      return fetchLessonsWithCourseContext(pathId, courseNumber, learningPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchLessons value) fetchLessons,
    required TResult Function(FetchLessonsWithCourseContext value)
        fetchLessonsWithCourseContext,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return fetchLessonsWithCourseContext(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return fetchLessonsWithCourseContext?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult Function(RefreshLessons value)? refreshLessons,
    TResult Function(GetUserPreferences value)? getUserPreferences,
    required TResult orElse(),
  }) {
    if (fetchLessonsWithCourseContext != null) {
      return fetchLessonsWithCourseContext(this);
    }
    return orElse();
  }
}

abstract class FetchLessonsWithCourseContext implements DailyLessonsEvent {
  const factory FetchLessonsWithCourseContext(
          {required final String pathId,
          required final int courseNumber,
          required final LearningPath learningPath}) =
      _$FetchLessonsWithCourseContextImpl;

  String get pathId;
  int get courseNumber;
  LearningPath get learningPath;
  @JsonKey(ignore: true)
  _$$FetchLessonsWithCourseContextImplCopyWith<
          _$FetchLessonsWithCourseContextImpl>
      get copyWith => throw _privateConstructorUsedError;
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
    required TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)
        fetchLessonsWithCourseContext,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return refreshLessons();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return refreshLessons?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
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
    required TResult Function(FetchLessonsWithCourseContext value)
        fetchLessonsWithCourseContext,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return refreshLessons(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return refreshLessons?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
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
    required TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)
        fetchLessonsWithCourseContext,
    required TResult Function() refreshLessons,
    required TResult Function() getUserPreferences,
  }) {
    return getUserPreferences();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchLessons,
    TResult? Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
    TResult? Function()? refreshLessons,
    TResult? Function()? getUserPreferences,
  }) {
    return getUserPreferences?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchLessons,
    TResult Function(
            String pathId, int courseNumber, LearningPath learningPath)?
        fetchLessonsWithCourseContext,
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
    required TResult Function(FetchLessonsWithCourseContext value)
        fetchLessonsWithCourseContext,
    required TResult Function(RefreshLessons value) refreshLessons,
    required TResult Function(GetUserPreferences value) getUserPreferences,
  }) {
    return getUserPreferences(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchLessons value)? fetchLessons,
    TResult? Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
    TResult? Function(RefreshLessons value)? refreshLessons,
    TResult? Function(GetUserPreferences value)? getUserPreferences,
  }) {
    return getUserPreferences?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchLessons value)? fetchLessons,
    TResult Function(FetchLessonsWithCourseContext value)?
        fetchLessonsWithCourseContext,
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
