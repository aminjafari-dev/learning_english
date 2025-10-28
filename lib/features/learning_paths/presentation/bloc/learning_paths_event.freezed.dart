// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_paths_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningPathsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathsEventCopyWith<$Res> {
  factory $LearningPathsEventCopyWith(
          LearningPathsEvent value, $Res Function(LearningPathsEvent) then) =
      _$LearningPathsEventCopyWithImpl<$Res, LearningPathsEvent>;
}

/// @nodoc
class _$LearningPathsEventCopyWithImpl<$Res, $Val extends LearningPathsEvent>
    implements $LearningPathsEventCopyWith<$Res> {
  _$LearningPathsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GenerateSubCategoriesImplCopyWith<$Res> {
  factory _$$GenerateSubCategoriesImplCopyWith(
          _$GenerateSubCategoriesImpl value,
          $Res Function(_$GenerateSubCategoriesImpl) then) =
      __$$GenerateSubCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Level level, List<String> focusAreas});
}

/// @nodoc
class __$$GenerateSubCategoriesImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$GenerateSubCategoriesImpl>
    implements _$$GenerateSubCategoriesImplCopyWith<$Res> {
  __$$GenerateSubCategoriesImplCopyWithImpl(_$GenerateSubCategoriesImpl _value,
      $Res Function(_$GenerateSubCategoriesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? focusAreas = null,
  }) {
    return _then(_$GenerateSubCategoriesImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      focusAreas: null == focusAreas
          ? _value._focusAreas
          : focusAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$GenerateSubCategoriesImpl implements GenerateSubCategories {
  const _$GenerateSubCategoriesImpl(
      {required this.level, required final List<String> focusAreas})
      : _focusAreas = focusAreas;

  @override
  final Level level;
  final List<String> _focusAreas;
  @override
  List<String> get focusAreas {
    if (_focusAreas is EqualUnmodifiableListView) return _focusAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_focusAreas);
  }

  @override
  String toString() {
    return 'LearningPathsEvent.generateSubCategories(level: $level, focusAreas: $focusAreas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateSubCategoriesImpl &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._focusAreas, _focusAreas));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, level, const DeepCollectionEquality().hash(_focusAreas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateSubCategoriesImplCopyWith<_$GenerateSubCategoriesImpl>
      get copyWith => __$$GenerateSubCategoriesImplCopyWithImpl<
          _$GenerateSubCategoriesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return generateSubCategories(level, focusAreas);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return generateSubCategories?.call(level, focusAreas);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (generateSubCategories != null) {
      return generateSubCategories(level, focusAreas);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return generateSubCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return generateSubCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (generateSubCategories != null) {
      return generateSubCategories(this);
    }
    return orElse();
  }
}

abstract class GenerateSubCategories implements LearningPathsEvent {
  const factory GenerateSubCategories(
      {required final Level level,
      required final List<String> focusAreas}) = _$GenerateSubCategoriesImpl;

  Level get level;
  List<String> get focusAreas;
  @JsonKey(ignore: true)
  _$$GenerateSubCategoriesImplCopyWith<_$GenerateSubCategoriesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectSubCategoryImplCopyWith<$Res> {
  factory _$$SelectSubCategoryImplCopyWith(_$SelectSubCategoryImpl value,
          $Res Function(_$SelectSubCategoryImpl) then) =
      __$$SelectSubCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SubCategory subCategory, Level level, List<String> focusAreas});
}

/// @nodoc
class __$$SelectSubCategoryImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$SelectSubCategoryImpl>
    implements _$$SelectSubCategoryImplCopyWith<$Res> {
  __$$SelectSubCategoryImplCopyWithImpl(_$SelectSubCategoryImpl _value,
      $Res Function(_$SelectSubCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subCategory = null,
    Object? level = null,
    Object? focusAreas = null,
  }) {
    return _then(_$SelectSubCategoryImpl(
      subCategory: null == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as Level,
      focusAreas: null == focusAreas
          ? _value._focusAreas
          : focusAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$SelectSubCategoryImpl implements SelectSubCategory {
  const _$SelectSubCategoryImpl(
      {required this.subCategory,
      required this.level,
      required final List<String> focusAreas})
      : _focusAreas = focusAreas;

  @override
  final SubCategory subCategory;
  @override
  final Level level;
  final List<String> _focusAreas;
  @override
  List<String> get focusAreas {
    if (_focusAreas is EqualUnmodifiableListView) return _focusAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_focusAreas);
  }

  @override
  String toString() {
    return 'LearningPathsEvent.selectSubCategory(subCategory: $subCategory, level: $level, focusAreas: $focusAreas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectSubCategoryImpl &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._focusAreas, _focusAreas));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subCategory, level,
      const DeepCollectionEquality().hash(_focusAreas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectSubCategoryImplCopyWith<_$SelectSubCategoryImpl> get copyWith =>
      __$$SelectSubCategoryImplCopyWithImpl<_$SelectSubCategoryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return selectSubCategory(subCategory, level, focusAreas);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return selectSubCategory?.call(subCategory, level, focusAreas);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (selectSubCategory != null) {
      return selectSubCategory(subCategory, level, focusAreas);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return selectSubCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return selectSubCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (selectSubCategory != null) {
      return selectSubCategory(this);
    }
    return orElse();
  }
}

abstract class SelectSubCategory implements LearningPathsEvent {
  const factory SelectSubCategory(
      {required final SubCategory subCategory,
      required final Level level,
      required final List<String> focusAreas}) = _$SelectSubCategoryImpl;

  SubCategory get subCategory;
  Level get level;
  List<String> get focusAreas;
  @JsonKey(ignore: true)
  _$$SelectSubCategoryImplCopyWith<_$SelectSubCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadAllPathsImplCopyWith<$Res> {
  factory _$$LoadAllPathsImplCopyWith(
          _$LoadAllPathsImpl value, $Res Function(_$LoadAllPathsImpl) then) =
      __$$LoadAllPathsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadAllPathsImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$LoadAllPathsImpl>
    implements _$$LoadAllPathsImplCopyWith<$Res> {
  __$$LoadAllPathsImplCopyWithImpl(
      _$LoadAllPathsImpl _value, $Res Function(_$LoadAllPathsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadAllPathsImpl implements LoadAllPaths {
  const _$LoadAllPathsImpl();

  @override
  String toString() {
    return 'LearningPathsEvent.loadAllPaths()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadAllPathsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return loadAllPaths();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return loadAllPaths?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadAllPaths != null) {
      return loadAllPaths();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return loadAllPaths(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return loadAllPaths?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (loadAllPaths != null) {
      return loadAllPaths(this);
    }
    return orElse();
  }
}

abstract class LoadAllPaths implements LearningPathsEvent {
  const factory LoadAllPaths() = _$LoadAllPathsImpl;
}

/// @nodoc
abstract class _$$LoadPathByIdImplCopyWith<$Res> {
  factory _$$LoadPathByIdImplCopyWith(
          _$LoadPathByIdImpl value, $Res Function(_$LoadPathByIdImpl) then) =
      __$$LoadPathByIdImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String pathId});
}

/// @nodoc
class __$$LoadPathByIdImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$LoadPathByIdImpl>
    implements _$$LoadPathByIdImplCopyWith<$Res> {
  __$$LoadPathByIdImplCopyWithImpl(
      _$LoadPathByIdImpl _value, $Res Function(_$LoadPathByIdImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
  }) {
    return _then(_$LoadPathByIdImpl(
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadPathByIdImpl implements LoadPathById {
  const _$LoadPathByIdImpl({required this.pathId});

  @override
  final String pathId;

  @override
  String toString() {
    return 'LearningPathsEvent.loadPathById(pathId: $pathId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadPathByIdImpl &&
            (identical(other.pathId, pathId) || other.pathId == pathId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pathId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadPathByIdImplCopyWith<_$LoadPathByIdImpl> get copyWith =>
      __$$LoadPathByIdImplCopyWithImpl<_$LoadPathByIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return loadPathById(pathId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return loadPathById?.call(pathId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadPathById != null) {
      return loadPathById(pathId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return loadPathById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return loadPathById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (loadPathById != null) {
      return loadPathById(this);
    }
    return orElse();
  }
}

abstract class LoadPathById implements LearningPathsEvent {
  const factory LoadPathById({required final String pathId}) =
      _$LoadPathByIdImpl;

  String get pathId;
  @JsonKey(ignore: true)
  _$$LoadPathByIdImplCopyWith<_$LoadPathByIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadActivePathImplCopyWith<$Res> {
  factory _$$LoadActivePathImplCopyWith(_$LoadActivePathImpl value,
          $Res Function(_$LoadActivePathImpl) then) =
      __$$LoadActivePathImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadActivePathImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$LoadActivePathImpl>
    implements _$$LoadActivePathImplCopyWith<$Res> {
  __$$LoadActivePathImplCopyWithImpl(
      _$LoadActivePathImpl _value, $Res Function(_$LoadActivePathImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadActivePathImpl implements LoadActivePath {
  const _$LoadActivePathImpl();

  @override
  String toString() {
    return 'LearningPathsEvent.loadActivePath()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadActivePathImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return loadActivePath();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return loadActivePath?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (loadActivePath != null) {
      return loadActivePath();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return loadActivePath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return loadActivePath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (loadActivePath != null) {
      return loadActivePath(this);
    }
    return orElse();
  }
}

abstract class LoadActivePath implements LearningPathsEvent {
  const factory LoadActivePath() = _$LoadActivePathImpl;
}

/// @nodoc
abstract class _$$CompleteCourseImplCopyWith<$Res> {
  factory _$$CompleteCourseImplCopyWith(_$CompleteCourseImpl value,
          $Res Function(_$CompleteCourseImpl) then) =
      __$$CompleteCourseImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String pathId, int courseNumber});
}

/// @nodoc
class __$$CompleteCourseImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$CompleteCourseImpl>
    implements _$$CompleteCourseImplCopyWith<$Res> {
  __$$CompleteCourseImplCopyWithImpl(
      _$CompleteCourseImpl _value, $Res Function(_$CompleteCourseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
    Object? courseNumber = null,
  }) {
    return _then(_$CompleteCourseImpl(
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
      courseNumber: null == courseNumber
          ? _value.courseNumber
          : courseNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CompleteCourseImpl implements CompleteCourse {
  const _$CompleteCourseImpl(
      {required this.pathId, required this.courseNumber});

  @override
  final String pathId;
  @override
  final int courseNumber;

  @override
  String toString() {
    return 'LearningPathsEvent.completeCourse(pathId: $pathId, courseNumber: $courseNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteCourseImpl &&
            (identical(other.pathId, pathId) || other.pathId == pathId) &&
            (identical(other.courseNumber, courseNumber) ||
                other.courseNumber == courseNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pathId, courseNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteCourseImplCopyWith<_$CompleteCourseImpl> get copyWith =>
      __$$CompleteCourseImplCopyWithImpl<_$CompleteCourseImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return completeCourse(pathId, courseNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return completeCourse?.call(pathId, courseNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (completeCourse != null) {
      return completeCourse(pathId, courseNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return completeCourse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return completeCourse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (completeCourse != null) {
      return completeCourse(this);
    }
    return orElse();
  }
}

abstract class CompleteCourse implements LearningPathsEvent {
  const factory CompleteCourse(
      {required final String pathId,
      required final int courseNumber}) = _$CompleteCourseImpl;

  String get pathId;
  int get courseNumber;
  @JsonKey(ignore: true)
  _$$CompleteCourseImplCopyWith<_$CompleteCourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeletePathImplCopyWith<$Res> {
  factory _$$DeletePathImplCopyWith(
          _$DeletePathImpl value, $Res Function(_$DeletePathImpl) then) =
      __$$DeletePathImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String pathId});
}

/// @nodoc
class __$$DeletePathImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$DeletePathImpl>
    implements _$$DeletePathImplCopyWith<$Res> {
  __$$DeletePathImplCopyWithImpl(
      _$DeletePathImpl _value, $Res Function(_$DeletePathImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathId = null,
  }) {
    return _then(_$DeletePathImpl(
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeletePathImpl implements DeletePath {
  const _$DeletePathImpl({required this.pathId});

  @override
  final String pathId;

  @override
  String toString() {
    return 'LearningPathsEvent.deletePath(pathId: $pathId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletePathImpl &&
            (identical(other.pathId, pathId) || other.pathId == pathId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pathId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletePathImplCopyWith<_$DeletePathImpl> get copyWith =>
      __$$DeletePathImplCopyWithImpl<_$DeletePathImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return deletePath(pathId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return deletePath?.call(pathId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (deletePath != null) {
      return deletePath(pathId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return deletePath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return deletePath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (deletePath != null) {
      return deletePath(this);
    }
    return orElse();
  }
}

abstract class DeletePath implements LearningPathsEvent {
  const factory DeletePath({required final String pathId}) = _$DeletePathImpl;

  String get pathId;
  @JsonKey(ignore: true)
  _$$DeletePathImplCopyWith<_$DeletePathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshImplCopyWith<$Res> {
  factory _$$RefreshImplCopyWith(
          _$RefreshImpl value, $Res Function(_$RefreshImpl) then) =
      __$$RefreshImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshImplCopyWithImpl<$Res>
    extends _$LearningPathsEventCopyWithImpl<$Res, _$RefreshImpl>
    implements _$$RefreshImplCopyWith<$Res> {
  __$$RefreshImplCopyWithImpl(
      _$RefreshImpl _value, $Res Function(_$RefreshImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RefreshImpl implements Refresh {
  const _$RefreshImpl();

  @override
  String toString() {
    return 'LearningPathsEvent.refresh()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Level level, List<String> focusAreas)
        generateSubCategories,
    required TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)
        selectSubCategory,
    required TResult Function() loadAllPaths,
    required TResult Function(String pathId) loadPathById,
    required TResult Function() loadActivePath,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult? Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult? Function()? loadAllPaths,
    TResult? Function(String pathId)? loadPathById,
    TResult? Function()? loadActivePath,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Level level, List<String> focusAreas)?
        generateSubCategories,
    TResult Function(
            SubCategory subCategory, Level level, List<String> focusAreas)?
        selectSubCategory,
    TResult Function()? loadAllPaths,
    TResult Function(String pathId)? loadPathById,
    TResult Function()? loadActivePath,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateSubCategories value)
        generateSubCategories,
    required TResult Function(SelectSubCategory value) selectSubCategory,
    required TResult Function(LoadAllPaths value) loadAllPaths,
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(LoadActivePath value) loadActivePath,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateSubCategories value)? generateSubCategories,
    TResult? Function(SelectSubCategory value)? selectSubCategory,
    TResult? Function(LoadAllPaths value)? loadAllPaths,
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(LoadActivePath value)? loadActivePath,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateSubCategories value)? generateSubCategories,
    TResult Function(SelectSubCategory value)? selectSubCategory,
    TResult Function(LoadAllPaths value)? loadAllPaths,
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(LoadActivePath value)? loadActivePath,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }
}

abstract class Refresh implements LearningPathsEvent {
  const factory Refresh() = _$RefreshImpl;
}
