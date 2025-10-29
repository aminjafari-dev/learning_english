// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningPathDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathDetailStateCopyWith<$Res> {
  factory $LearningPathDetailStateCopyWith(LearningPathDetailState value,
          $Res Function(LearningPathDetailState) then) =
      _$LearningPathDetailStateCopyWithImpl<$Res, LearningPathDetailState>;
}

/// @nodoc
class _$LearningPathDetailStateCopyWithImpl<$Res,
        $Val extends LearningPathDetailState>
    implements $LearningPathDetailStateCopyWith<$Res> {
  _$LearningPathDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'LearningPathDetailState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
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
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements LearningPathDetailState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'LearningPathDetailState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements LearningPathDetailState {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$PathLoadedImplCopyWith<$Res> {
  factory _$$PathLoadedImplCopyWith(
          _$PathLoadedImpl value, $Res Function(_$PathLoadedImpl) then) =
      __$$PathLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LearningPath learningPath});
}

/// @nodoc
class __$$PathLoadedImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$PathLoadedImpl>
    implements _$$PathLoadedImplCopyWith<$Res> {
  __$$PathLoadedImplCopyWithImpl(
      _$PathLoadedImpl _value, $Res Function(_$PathLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? learningPath = null,
  }) {
    return _then(_$PathLoadedImpl(
      learningPath: null == learningPath
          ? _value.learningPath
          : learningPath // ignore: cast_nullable_to_non_nullable
              as LearningPath,
    ));
  }
}

/// @nodoc

class _$PathLoadedImpl implements PathLoaded {
  const _$PathLoadedImpl({required this.learningPath});

  @override
  final LearningPath learningPath;

  @override
  String toString() {
    return 'LearningPathDetailState.pathLoaded(learningPath: $learningPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathLoadedImpl &&
            (identical(other.learningPath, learningPath) ||
                other.learningPath == learningPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, learningPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PathLoadedImplCopyWith<_$PathLoadedImpl> get copyWith =>
      __$$PathLoadedImplCopyWithImpl<_$PathLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return pathLoaded(learningPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return pathLoaded?.call(learningPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (pathLoaded != null) {
      return pathLoaded(learningPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return pathLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return pathLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (pathLoaded != null) {
      return pathLoaded(this);
    }
    return orElse();
  }
}

abstract class PathLoaded implements LearningPathDetailState {
  const factory PathLoaded({required final LearningPath learningPath}) =
      _$PathLoadedImpl;

  LearningPath get learningPath;
  @JsonKey(ignore: true)
  _$$PathLoadedImplCopyWith<_$PathLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CourseCompletedImplCopyWith<$Res> {
  factory _$$CourseCompletedImplCopyWith(_$CourseCompletedImpl value,
          $Res Function(_$CourseCompletedImpl) then) =
      __$$CourseCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int courseNumber, LearningPath updatedPath});
}

/// @nodoc
class __$$CourseCompletedImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$CourseCompletedImpl>
    implements _$$CourseCompletedImplCopyWith<$Res> {
  __$$CourseCompletedImplCopyWithImpl(
      _$CourseCompletedImpl _value, $Res Function(_$CourseCompletedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseNumber = null,
    Object? updatedPath = null,
  }) {
    return _then(_$CourseCompletedImpl(
      courseNumber: null == courseNumber
          ? _value.courseNumber
          : courseNumber // ignore: cast_nullable_to_non_nullable
              as int,
      updatedPath: null == updatedPath
          ? _value.updatedPath
          : updatedPath // ignore: cast_nullable_to_non_nullable
              as LearningPath,
    ));
  }
}

/// @nodoc

class _$CourseCompletedImpl implements CourseCompleted {
  const _$CourseCompletedImpl(
      {required this.courseNumber, required this.updatedPath});

  @override
  final int courseNumber;
  @override
  final LearningPath updatedPath;

  @override
  String toString() {
    return 'LearningPathDetailState.courseCompleted(courseNumber: $courseNumber, updatedPath: $updatedPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseCompletedImpl &&
            (identical(other.courseNumber, courseNumber) ||
                other.courseNumber == courseNumber) &&
            (identical(other.updatedPath, updatedPath) ||
                other.updatedPath == updatedPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, courseNumber, updatedPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseCompletedImplCopyWith<_$CourseCompletedImpl> get copyWith =>
      __$$CourseCompletedImplCopyWithImpl<_$CourseCompletedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return courseCompleted(courseNumber, updatedPath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return courseCompleted?.call(courseNumber, updatedPath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (courseCompleted != null) {
      return courseCompleted(courseNumber, updatedPath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return courseCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return courseCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (courseCompleted != null) {
      return courseCompleted(this);
    }
    return orElse();
  }
}

abstract class CourseCompleted implements LearningPathDetailState {
  const factory CourseCompleted(
      {required final int courseNumber,
      required final LearningPath updatedPath}) = _$CourseCompletedImpl;

  int get courseNumber;
  LearningPath get updatedPath;
  @JsonKey(ignore: true)
  _$$CourseCompletedImplCopyWith<_$CourseCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PathDeletedImplCopyWith<$Res> {
  factory _$$PathDeletedImplCopyWith(
          _$PathDeletedImpl value, $Res Function(_$PathDeletedImpl) then) =
      __$$PathDeletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PathDeletedImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$PathDeletedImpl>
    implements _$$PathDeletedImplCopyWith<$Res> {
  __$$PathDeletedImplCopyWithImpl(
      _$PathDeletedImpl _value, $Res Function(_$PathDeletedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PathDeletedImpl implements PathDeleted {
  const _$PathDeletedImpl();

  @override
  String toString() {
    return 'LearningPathDetailState.pathDeleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PathDeletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return pathDeleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return pathDeleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (pathDeleted != null) {
      return pathDeleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return pathDeleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return pathDeleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (pathDeleted != null) {
      return pathDeleted(this);
    }
    return orElse();
  }
}

abstract class PathDeleted implements LearningPathDetailState {
  const factory PathDeleted() = _$PathDeletedImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$LearningPathDetailStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'LearningPathDetailState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements LearningPathDetailState {
  const factory Error({required final String message}) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
