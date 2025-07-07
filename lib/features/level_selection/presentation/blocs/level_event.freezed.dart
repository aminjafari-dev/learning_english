// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LevelEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LevelEvent()';
}


}

/// @nodoc
class $LevelEventCopyWith<$Res>  {
$LevelEventCopyWith(LevelEvent _, $Res Function(LevelEvent) __);
}


/// Adds pattern-matching-related methods to [LevelEvent].
extension LevelEventPatterns on LevelEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LevelSelected value)?  levelSelected,TResult Function( LevelSubmitted value)?  levelSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LevelSelected() when levelSelected != null:
return levelSelected(_that);case LevelSubmitted() when levelSubmitted != null:
return levelSubmitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LevelSelected value)  levelSelected,required TResult Function( LevelSubmitted value)  levelSubmitted,}){
final _that = this;
switch (_that) {
case LevelSelected():
return levelSelected(_that);case LevelSubmitted():
return levelSubmitted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LevelSelected value)?  levelSelected,TResult? Function( LevelSubmitted value)?  levelSubmitted,}){
final _that = this;
switch (_that) {
case LevelSelected() when levelSelected != null:
return levelSelected(_that);case LevelSubmitted() when levelSubmitted != null:
return levelSubmitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Level level)?  levelSelected,TResult Function( String userId)?  levelSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LevelSelected() when levelSelected != null:
return levelSelected(_that.level);case LevelSubmitted() when levelSubmitted != null:
return levelSubmitted(_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Level level)  levelSelected,required TResult Function( String userId)  levelSubmitted,}) {final _that = this;
switch (_that) {
case LevelSelected():
return levelSelected(_that.level);case LevelSubmitted():
return levelSubmitted(_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Level level)?  levelSelected,TResult? Function( String userId)?  levelSubmitted,}) {final _that = this;
switch (_that) {
case LevelSelected() when levelSelected != null:
return levelSelected(_that.level);case LevelSubmitted() when levelSubmitted != null:
return levelSubmitted(_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class LevelSelected implements LevelEvent {
  const LevelSelected(this.level);
  

 final  Level level;

/// Create a copy of LevelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelSelectedCopyWith<LevelSelected> get copyWith => _$LevelSelectedCopyWithImpl<LevelSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelSelected&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'LevelEvent.levelSelected(level: $level)';
}


}

/// @nodoc
abstract mixin class $LevelSelectedCopyWith<$Res> implements $LevelEventCopyWith<$Res> {
  factory $LevelSelectedCopyWith(LevelSelected value, $Res Function(LevelSelected) _then) = _$LevelSelectedCopyWithImpl;
@useResult
$Res call({
 Level level
});




}
/// @nodoc
class _$LevelSelectedCopyWithImpl<$Res>
    implements $LevelSelectedCopyWith<$Res> {
  _$LevelSelectedCopyWithImpl(this._self, this._then);

  final LevelSelected _self;
  final $Res Function(LevelSelected) _then;

/// Create a copy of LevelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(LevelSelected(
null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as Level,
  ));
}


}

/// @nodoc


class LevelSubmitted implements LevelEvent {
  const LevelSubmitted(this.userId);
  

 final  String userId;

/// Create a copy of LevelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelSubmittedCopyWith<LevelSubmitted> get copyWith => _$LevelSubmittedCopyWithImpl<LevelSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelSubmitted&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'LevelEvent.levelSubmitted(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LevelSubmittedCopyWith<$Res> implements $LevelEventCopyWith<$Res> {
  factory $LevelSubmittedCopyWith(LevelSubmitted value, $Res Function(LevelSubmitted) _then) = _$LevelSubmittedCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LevelSubmittedCopyWithImpl<$Res>
    implements $LevelSubmittedCopyWith<$Res> {
  _$LevelSubmittedCopyWithImpl(this._self, this._then);

  final LevelSubmitted _self;
  final $Res Function(LevelSubmitted) _then;

/// Create a copy of LevelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LevelSubmitted(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
