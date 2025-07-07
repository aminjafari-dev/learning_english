// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LevelState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LevelState()';
}


}

/// @nodoc
class $LevelStateCopyWith<$Res>  {
$LevelStateCopyWith(LevelState _, $Res Function(LevelState) __);
}


/// Adds pattern-matching-related methods to [LevelState].
extension LevelStatePatterns on LevelState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LevelInitial value)?  initial,TResult Function( LevelSelectionMade value)?  selectionMade,TResult Function( LevelLoading value)?  loading,TResult Function( LevelSuccess value)?  success,TResult Function( LevelError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LevelInitial() when initial != null:
return initial(_that);case LevelSelectionMade() when selectionMade != null:
return selectionMade(_that);case LevelLoading() when loading != null:
return loading(_that);case LevelSuccess() when success != null:
return success(_that);case LevelError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LevelInitial value)  initial,required TResult Function( LevelSelectionMade value)  selectionMade,required TResult Function( LevelLoading value)  loading,required TResult Function( LevelSuccess value)  success,required TResult Function( LevelError value)  error,}){
final _that = this;
switch (_that) {
case LevelInitial():
return initial(_that);case LevelSelectionMade():
return selectionMade(_that);case LevelLoading():
return loading(_that);case LevelSuccess():
return success(_that);case LevelError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LevelInitial value)?  initial,TResult? Function( LevelSelectionMade value)?  selectionMade,TResult? Function( LevelLoading value)?  loading,TResult? Function( LevelSuccess value)?  success,TResult? Function( LevelError value)?  error,}){
final _that = this;
switch (_that) {
case LevelInitial() when initial != null:
return initial(_that);case LevelSelectionMade() when selectionMade != null:
return selectionMade(_that);case LevelLoading() when loading != null:
return loading(_that);case LevelSuccess() when success != null:
return success(_that);case LevelError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( Level level)?  selectionMade,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LevelInitial() when initial != null:
return initial();case LevelSelectionMade() when selectionMade != null:
return selectionMade(_that.level);case LevelLoading() when loading != null:
return loading();case LevelSuccess() when success != null:
return success();case LevelError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( Level level)  selectionMade,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LevelInitial():
return initial();case LevelSelectionMade():
return selectionMade(_that.level);case LevelLoading():
return loading();case LevelSuccess():
return success();case LevelError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( Level level)?  selectionMade,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LevelInitial() when initial != null:
return initial();case LevelSelectionMade() when selectionMade != null:
return selectionMade(_that.level);case LevelLoading() when loading != null:
return loading();case LevelSuccess() when success != null:
return success();case LevelError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LevelInitial implements LevelState {
  const LevelInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LevelState.initial()';
}


}




/// @nodoc


class LevelSelectionMade implements LevelState {
  const LevelSelectionMade(this.level);
  

 final  Level level;

/// Create a copy of LevelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelSelectionMadeCopyWith<LevelSelectionMade> get copyWith => _$LevelSelectionMadeCopyWithImpl<LevelSelectionMade>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelSelectionMade&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'LevelState.selectionMade(level: $level)';
}


}

/// @nodoc
abstract mixin class $LevelSelectionMadeCopyWith<$Res> implements $LevelStateCopyWith<$Res> {
  factory $LevelSelectionMadeCopyWith(LevelSelectionMade value, $Res Function(LevelSelectionMade) _then) = _$LevelSelectionMadeCopyWithImpl;
@useResult
$Res call({
 Level level
});




}
/// @nodoc
class _$LevelSelectionMadeCopyWithImpl<$Res>
    implements $LevelSelectionMadeCopyWith<$Res> {
  _$LevelSelectionMadeCopyWithImpl(this._self, this._then);

  final LevelSelectionMade _self;
  final $Res Function(LevelSelectionMade) _then;

/// Create a copy of LevelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(LevelSelectionMade(
null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,
  ));
}


}

/// @nodoc


class LevelLoading implements LevelState {
  const LevelLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LevelState.loading()';
}


}




/// @nodoc


class LevelSuccess implements LevelState {
  const LevelSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LevelState.success()';
}


}




/// @nodoc


class LevelError implements LevelState {
  const LevelError(this.message);
  

 final  String message;

/// Create a copy of LevelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelErrorCopyWith<LevelError> get copyWith => _$LevelErrorCopyWithImpl<LevelError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LevelState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $LevelErrorCopyWith<$Res> implements $LevelStateCopyWith<$Res> {
  factory $LevelErrorCopyWith(LevelError value, $Res Function(LevelError) _then) = _$LevelErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LevelErrorCopyWithImpl<$Res>
    implements $LevelErrorCopyWith<$Res> {
  _$LevelErrorCopyWithImpl(this._self, this._then);

  final LevelError _self;
  final $Res Function(LevelError) _then;

/// Create a copy of LevelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LevelError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
