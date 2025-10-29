// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_path_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LearningPathDetailEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String pathId) loadPathById,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pathId)? loadPathById,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pathId)? loadPathById,
    TResult Function(String pathId, int courseNumber)? completeCourse,
    TResult Function(String pathId)? deletePath,
    TResult Function()? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadPathById value)? loadPathById,
    TResult Function(CompleteCourse value)? completeCourse,
    TResult Function(DeletePath value)? deletePath,
    TResult Function(Refresh value)? refresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPathDetailEventCopyWith<$Res> {
  factory $LearningPathDetailEventCopyWith(LearningPathDetailEvent value,
          $Res Function(LearningPathDetailEvent) then) =
      _$LearningPathDetailEventCopyWithImpl<$Res, LearningPathDetailEvent>;
}

/// @nodoc
class _$LearningPathDetailEventCopyWithImpl<$Res,
        $Val extends LearningPathDetailEvent>
    implements $LearningPathDetailEventCopyWith<$Res> {
  _$LearningPathDetailEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
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
    extends _$LearningPathDetailEventCopyWithImpl<$Res, _$LoadPathByIdImpl>
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
    return 'LearningPathDetailEvent.loadPathById(pathId: $pathId)';
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
    required TResult Function(String pathId) loadPathById,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return loadPathById(pathId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pathId)? loadPathById,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return loadPathById?.call(pathId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pathId)? loadPathById,
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
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return loadPathById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return loadPathById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadPathById value)? loadPathById,
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

abstract class LoadPathById implements LearningPathDetailEvent {
  const factory LoadPathById({required final String pathId}) =
      _$LoadPathByIdImpl;

  String get pathId;
  @JsonKey(ignore: true)
  _$$LoadPathByIdImplCopyWith<_$LoadPathByIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$LearningPathDetailEventCopyWithImpl<$Res, _$CompleteCourseImpl>
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
    return 'LearningPathDetailEvent.completeCourse(pathId: $pathId, courseNumber: $courseNumber)';
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
    required TResult Function(String pathId) loadPathById,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return completeCourse(pathId, courseNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pathId)? loadPathById,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return completeCourse?.call(pathId, courseNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pathId)? loadPathById,
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
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return completeCourse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return completeCourse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadPathById value)? loadPathById,
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

abstract class CompleteCourse implements LearningPathDetailEvent {
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
    extends _$LearningPathDetailEventCopyWithImpl<$Res, _$DeletePathImpl>
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
    return 'LearningPathDetailEvent.deletePath(pathId: $pathId)';
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
    required TResult Function(String pathId) loadPathById,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return deletePath(pathId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pathId)? loadPathById,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return deletePath?.call(pathId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pathId)? loadPathById,
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
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return deletePath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return deletePath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadPathById value)? loadPathById,
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

abstract class DeletePath implements LearningPathDetailEvent {
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
    extends _$LearningPathDetailEventCopyWithImpl<$Res, _$RefreshImpl>
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
    return 'LearningPathDetailEvent.refresh()';
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
    required TResult Function(String pathId) loadPathById,
    required TResult Function(String pathId, int courseNumber) completeCourse,
    required TResult Function(String pathId) deletePath,
    required TResult Function() refresh,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pathId)? loadPathById,
    TResult? Function(String pathId, int courseNumber)? completeCourse,
    TResult? Function(String pathId)? deletePath,
    TResult? Function()? refresh,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pathId)? loadPathById,
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
    required TResult Function(LoadPathById value) loadPathById,
    required TResult Function(CompleteCourse value) completeCourse,
    required TResult Function(DeletePath value) deletePath,
    required TResult Function(Refresh value) refresh,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadPathById value)? loadPathById,
    TResult? Function(CompleteCourse value)? completeCourse,
    TResult? Function(DeletePath value)? deletePath,
    TResult? Function(Refresh value)? refresh,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadPathById value)? loadPathById,
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

abstract class Refresh implements LearningPathDetailEvent {
  const factory Refresh() = _$RefreshImpl;
}
