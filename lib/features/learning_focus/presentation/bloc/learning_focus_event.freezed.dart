// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_focus_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningFocusEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningFocusEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LearningFocusEvent()';
}


}

/// @nodoc
class $LearningFocusEventCopyWith<$Res>  {
$LearningFocusEventCopyWith(LearningFocusEvent _, $Res Function(LearningFocusEvent) __);
}


/// Adds pattern-matching-related methods to [LearningFocusEvent].
extension LearningFocusEventPatterns on LearningFocusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadOptions value)?  loadOptions,TResult Function( ToggleSelection value)?  toggleSelection,TResult Function( SaveSelections value)?  saveSelections,TResult Function( LoadUserSelections value)?  loadUserSelections,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadOptions() when loadOptions != null:
return loadOptions(_that);case ToggleSelection() when toggleSelection != null:
return toggleSelection(_that);case SaveSelections() when saveSelections != null:
return saveSelections(_that);case LoadUserSelections() when loadUserSelections != null:
return loadUserSelections(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadOptions value)  loadOptions,required TResult Function( ToggleSelection value)  toggleSelection,required TResult Function( SaveSelections value)  saveSelections,required TResult Function( LoadUserSelections value)  loadUserSelections,}){
final _that = this;
switch (_that) {
case LoadOptions():
return loadOptions(_that);case ToggleSelection():
return toggleSelection(_that);case SaveSelections():
return saveSelections(_that);case LoadUserSelections():
return loadUserSelections(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadOptions value)?  loadOptions,TResult? Function( ToggleSelection value)?  toggleSelection,TResult? Function( SaveSelections value)?  saveSelections,TResult? Function( LoadUserSelections value)?  loadUserSelections,}){
final _that = this;
switch (_that) {
case LoadOptions() when loadOptions != null:
return loadOptions(_that);case ToggleSelection() when toggleSelection != null:
return toggleSelection(_that);case SaveSelections() when saveSelections != null:
return saveSelections(_that);case LoadUserSelections() when loadUserSelections != null:
return loadUserSelections(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadOptions,TResult Function( LearningFocusType focusType)?  toggleSelection,TResult Function( String userId)?  saveSelections,TResult Function( String userId)?  loadUserSelections,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadOptions() when loadOptions != null:
return loadOptions();case ToggleSelection() when toggleSelection != null:
return toggleSelection(_that.focusType);case SaveSelections() when saveSelections != null:
return saveSelections(_that.userId);case LoadUserSelections() when loadUserSelections != null:
return loadUserSelections(_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadOptions,required TResult Function( LearningFocusType focusType)  toggleSelection,required TResult Function( String userId)  saveSelections,required TResult Function( String userId)  loadUserSelections,}) {final _that = this;
switch (_that) {
case LoadOptions():
return loadOptions();case ToggleSelection():
return toggleSelection(_that.focusType);case SaveSelections():
return saveSelections(_that.userId);case LoadUserSelections():
return loadUserSelections(_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadOptions,TResult? Function( LearningFocusType focusType)?  toggleSelection,TResult? Function( String userId)?  saveSelections,TResult? Function( String userId)?  loadUserSelections,}) {final _that = this;
switch (_that) {
case LoadOptions() when loadOptions != null:
return loadOptions();case ToggleSelection() when toggleSelection != null:
return toggleSelection(_that.focusType);case SaveSelections() when saveSelections != null:
return saveSelections(_that.userId);case LoadUserSelections() when loadUserSelections != null:
return loadUserSelections(_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class LoadOptions implements LearningFocusEvent {
  const LoadOptions();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadOptions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LearningFocusEvent.loadOptions()';
}


}




/// @nodoc


class ToggleSelection implements LearningFocusEvent {
  const ToggleSelection(this.focusType);
  

 final  LearningFocusType focusType;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleSelectionCopyWith<ToggleSelection> get copyWith => _$ToggleSelectionCopyWithImpl<ToggleSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleSelection&&(identical(other.focusType, focusType) || other.focusType == focusType));
}


@override
int get hashCode => Object.hash(runtimeType,focusType);

@override
String toString() {
  return 'LearningFocusEvent.toggleSelection(focusType: $focusType)';
}


}

/// @nodoc
abstract mixin class $ToggleSelectionCopyWith<$Res> implements $LearningFocusEventCopyWith<$Res> {
  factory $ToggleSelectionCopyWith(ToggleSelection value, $Res Function(ToggleSelection) _then) = _$ToggleSelectionCopyWithImpl;
@useResult
$Res call({
 LearningFocusType focusType
});




}
/// @nodoc
class _$ToggleSelectionCopyWithImpl<$Res>
    implements $ToggleSelectionCopyWith<$Res> {
  _$ToggleSelectionCopyWithImpl(this._self, this._then);

  final ToggleSelection _self;
  final $Res Function(ToggleSelection) _then;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? focusType = null,}) {
  return _then(ToggleSelection(
null == focusType ? _self.focusType : focusType // ignore: cast_nullable_to_non_nullable
as LearningFocusType,
  ));
}


}

/// @nodoc


class SaveSelections implements LearningFocusEvent {
  const SaveSelections(this.userId);
  

 final  String userId;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveSelectionsCopyWith<SaveSelections> get copyWith => _$SaveSelectionsCopyWithImpl<SaveSelections>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveSelections&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'LearningFocusEvent.saveSelections(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $SaveSelectionsCopyWith<$Res> implements $LearningFocusEventCopyWith<$Res> {
  factory $SaveSelectionsCopyWith(SaveSelections value, $Res Function(SaveSelections) _then) = _$SaveSelectionsCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$SaveSelectionsCopyWithImpl<$Res>
    implements $SaveSelectionsCopyWith<$Res> {
  _$SaveSelectionsCopyWithImpl(this._self, this._then);

  final SaveSelections _self;
  final $Res Function(SaveSelections) _then;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(SaveSelections(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadUserSelections implements LearningFocusEvent {
  const LoadUserSelections(this.userId);
  

 final  String userId;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadUserSelectionsCopyWith<LoadUserSelections> get copyWith => _$LoadUserSelectionsCopyWithImpl<LoadUserSelections>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUserSelections&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'LearningFocusEvent.loadUserSelections(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadUserSelectionsCopyWith<$Res> implements $LearningFocusEventCopyWith<$Res> {
  factory $LoadUserSelectionsCopyWith(LoadUserSelections value, $Res Function(LoadUserSelections) _then) = _$LoadUserSelectionsCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadUserSelectionsCopyWithImpl<$Res>
    implements $LoadUserSelectionsCopyWith<$Res> {
  _$LoadUserSelectionsCopyWithImpl(this._self, this._then);

  final LoadUserSelections _self;
  final $Res Function(LoadUserSelections) _then;

/// Create a copy of LearningFocusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadUserSelections(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
