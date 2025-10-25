// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_paths_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningPathsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathsStateCopyWith<$Res> {
  factory $LearningPathsStateCopyWith(
          LearningPathsState value, $Res Function(LearningPathsState) then) =
      _$LearningPathsStateCopyWithImpl<$Res, LearningPathsState>;
}

/// @nodoc
class _$LearningPathsStateCopyWithImpl<$Res, $Val extends LearningPathsState>
    implements $LearningPathsStateCopyWith<$Res> {
  _$LearningPathsStateCopyWithImpl(this._value, this._then);

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
    extends _$LearningPathsStateCopyWithImpl<$Res, _$InitialImpl>
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
    return 'LearningPathsState.initial()';
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
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
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
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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

abstract class Initial implements LearningPathsState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingSubCategoriesImplCopyWith<$Res> {
  factory _$$LoadingSubCategoriesImplCopyWith(_$LoadingSubCategoriesImpl value,
          $Res Function(_$LoadingSubCategoriesImpl) then) =
      __$$LoadingSubCategoriesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingSubCategoriesImplCopyWithImpl<$Res>
    extends _$LearningPathsStateCopyWithImpl<$Res, _$LoadingSubCategoriesImpl>
    implements _$$LoadingSubCategoriesImplCopyWith<$Res> {
  __$$LoadingSubCategoriesImplCopyWithImpl(_$LoadingSubCategoriesImpl _value,
      $Res Function(_$LoadingSubCategoriesImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingSubCategoriesImpl implements LoadingSubCategories {
  const _$LoadingSubCategoriesImpl();

  @override
  String toString() {
    return 'LearningPathsState.loadingSubCategories()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingSubCategoriesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return loadingSubCategories();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return loadingSubCategories?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loadingSubCategories != null) {
      return loadingSubCategories();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return loadingSubCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return loadingSubCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loadingSubCategories != null) {
      return loadingSubCategories(this);
    }
    return orElse();
  }
}

abstract class LoadingSubCategories implements LearningPathsState {
  const factory LoadingSubCategories() = _$LoadingSubCategoriesImpl;
}

/// @nodoc
abstract class _$$SubCategoriesLoadedImplCopyWith<$Res> {
  factory _$$SubCategoriesLoadedImplCopyWith(_$SubCategoriesLoadedImpl value,
          $Res Function(_$SubCategoriesLoadedImpl) then) =
      __$$SubCategoriesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SubCategory> subCategories});
}

/// @nodoc
class __$$SubCategoriesLoadedImplCopyWithImpl<$Res>
    extends _$LearningPathsStateCopyWithImpl<$Res, _$SubCategoriesLoadedImpl>
    implements _$$SubCategoriesLoadedImplCopyWith<$Res> {
  __$$SubCategoriesLoadedImplCopyWithImpl(_$SubCategoriesLoadedImpl _value,
      $Res Function(_$SubCategoriesLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subCategories = null,
  }) {
    return _then(_$SubCategoriesLoadedImpl(
      subCategories: null == subCategories
          ? _value._subCategories
          : subCategories // ignore: cast_nullable_to_non_nullable
              as List<SubCategory>,
    ));
  }
}

/// @nodoc

class _$SubCategoriesLoadedImpl implements SubCategoriesLoaded {
  const _$SubCategoriesLoadedImpl(
      {required final List<SubCategory> subCategories})
      : _subCategories = subCategories;

  final List<SubCategory> _subCategories;
  @override
  List<SubCategory> get subCategories {
    if (_subCategories is EqualUnmodifiableListView) return _subCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subCategories);
  }

  @override
  String toString() {
    return 'LearningPathsState.subCategoriesLoaded(subCategories: $subCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubCategoriesLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._subCategories, _subCategories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_subCategories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubCategoriesLoadedImplCopyWith<_$SubCategoriesLoadedImpl> get copyWith =>
      __$$SubCategoriesLoadedImplCopyWithImpl<_$SubCategoriesLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
    required TResult Function(LearningPath learningPath) pathLoaded,
    required TResult Function(int courseNumber, LearningPath updatedPath)
        courseCompleted,
    required TResult Function() pathDeleted,
    required TResult Function(String message) error,
  }) {
    return subCategoriesLoaded(subCategories);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
    TResult? Function(LearningPath learningPath)? pathLoaded,
    TResult? Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult? Function()? pathDeleted,
    TResult? Function(String message)? error,
  }) {
    return subCategoriesLoaded?.call(subCategories);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
    TResult Function(LearningPath learningPath)? pathLoaded,
    TResult Function(int courseNumber, LearningPath updatedPath)?
        courseCompleted,
    TResult Function()? pathDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (subCategoriesLoaded != null) {
      return subCategoriesLoaded(subCategories);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
    required TResult Function(PathLoaded value) pathLoaded,
    required TResult Function(CourseCompleted value) courseCompleted,
    required TResult Function(PathDeleted value) pathDeleted,
    required TResult Function(Error value) error,
  }) {
    return subCategoriesLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult? Function(PathLoaded value)? pathLoaded,
    TResult? Function(CourseCompleted value)? courseCompleted,
    TResult? Function(PathDeleted value)? pathDeleted,
    TResult? Function(Error value)? error,
  }) {
    return subCategoriesLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
    TResult Function(PathLoaded value)? pathLoaded,
    TResult Function(CourseCompleted value)? courseCompleted,
    TResult Function(PathDeleted value)? pathDeleted,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (subCategoriesLoaded != null) {
      return subCategoriesLoaded(this);
    }
    return orElse();
  }
}

abstract class SubCategoriesLoaded implements LearningPathsState {
  const factory SubCategoriesLoaded(
          {required final List<SubCategory> subCategories}) =
      _$SubCategoriesLoadedImpl;

  List<SubCategory> get subCategories;
  @JsonKey(ignore: true)
  _$$SubCategoriesLoadedImplCopyWith<_$SubCategoriesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$LearningPathsStateCopyWithImpl<$Res, _$PathLoadedImpl>
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
    return 'LearningPathsState.pathLoaded(learningPath: $learningPath)';
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
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
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
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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

abstract class PathLoaded implements LearningPathsState {
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
    extends _$LearningPathsStateCopyWithImpl<$Res, _$CourseCompletedImpl>
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
    return 'LearningPathsState.courseCompleted(courseNumber: $courseNumber, updatedPath: $updatedPath)';
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
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
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
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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

abstract class CourseCompleted implements LearningPathsState {
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
    extends _$LearningPathsStateCopyWithImpl<$Res, _$PathDeletedImpl>
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
    return 'LearningPathsState.pathDeleted()';
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
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
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
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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

abstract class PathDeleted implements LearningPathsState {
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
    extends _$LearningPathsStateCopyWithImpl<$Res, _$ErrorImpl>
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
    return 'LearningPathsState.error(message: $message)';
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
    required TResult Function() loadingSubCategories,
    required TResult Function(List<SubCategory> subCategories)
        subCategoriesLoaded,
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
    TResult? Function()? loadingSubCategories,
    TResult? Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    TResult Function()? loadingSubCategories,
    TResult Function(List<SubCategory> subCategories)? subCategoriesLoaded,
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
    required TResult Function(LoadingSubCategories value) loadingSubCategories,
    required TResult Function(SubCategoriesLoaded value) subCategoriesLoaded,
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
    TResult? Function(LoadingSubCategories value)? loadingSubCategories,
    TResult? Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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
    TResult Function(LoadingSubCategories value)? loadingSubCategories,
    TResult Function(SubCategoriesLoaded value)? subCategoriesLoaded,
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

abstract class Error implements LearningPathsState {
  const factory Error({required final String message}) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
