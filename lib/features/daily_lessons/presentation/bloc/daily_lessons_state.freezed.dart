// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_lessons_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabulariesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabulariesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VocabulariesState()';
}


}

/// @nodoc
class $VocabulariesStateCopyWith<$Res>  {
$VocabulariesStateCopyWith(VocabulariesState _, $Res Function(VocabulariesState) __);
}


/// Adds pattern-matching-related methods to [VocabulariesState].
extension VocabulariesStatePatterns on VocabulariesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VocabulariesInitial value)?  initial,TResult Function( VocabulariesLoading value)?  loading,TResult Function( VocabulariesLoaded value)?  loaded,TResult Function( VocabulariesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VocabulariesInitial() when initial != null:
return initial(_that);case VocabulariesLoading() when loading != null:
return loading(_that);case VocabulariesLoaded() when loaded != null:
return loaded(_that);case VocabulariesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VocabulariesInitial value)  initial,required TResult Function( VocabulariesLoading value)  loading,required TResult Function( VocabulariesLoaded value)  loaded,required TResult Function( VocabulariesError value)  error,}){
final _that = this;
switch (_that) {
case VocabulariesInitial():
return initial(_that);case VocabulariesLoading():
return loading(_that);case VocabulariesLoaded():
return loaded(_that);case VocabulariesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VocabulariesInitial value)?  initial,TResult? Function( VocabulariesLoading value)?  loading,TResult? Function( VocabulariesLoaded value)?  loaded,TResult? Function( VocabulariesError value)?  error,}){
final _that = this;
switch (_that) {
case VocabulariesInitial() when initial != null:
return initial(_that);case VocabulariesLoading() when loading != null:
return loading(_that);case VocabulariesLoaded() when loaded != null:
return loaded(_that);case VocabulariesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Vocabulary> vocabularies)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VocabulariesInitial() when initial != null:
return initial();case VocabulariesLoading() when loading != null:
return loading();case VocabulariesLoaded() when loaded != null:
return loaded(_that.vocabularies);case VocabulariesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Vocabulary> vocabularies)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case VocabulariesInitial():
return initial();case VocabulariesLoading():
return loading();case VocabulariesLoaded():
return loaded(_that.vocabularies);case VocabulariesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Vocabulary> vocabularies)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case VocabulariesInitial() when initial != null:
return initial();case VocabulariesLoading() when loading != null:
return loading();case VocabulariesLoaded() when loaded != null:
return loaded(_that.vocabularies);case VocabulariesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class VocabulariesInitial implements VocabulariesState {
  const VocabulariesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabulariesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VocabulariesState.initial()';
}


}




/// @nodoc


class VocabulariesLoading implements VocabulariesState {
  const VocabulariesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabulariesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VocabulariesState.loading()';
}


}




/// @nodoc


class VocabulariesLoaded implements VocabulariesState {
  const VocabulariesLoaded(final  List<Vocabulary> vocabularies): _vocabularies = vocabularies;
  

 final  List<Vocabulary> _vocabularies;
 List<Vocabulary> get vocabularies {
  if (_vocabularies is EqualUnmodifiableListView) return _vocabularies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vocabularies);
}


/// Create a copy of VocabulariesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabulariesLoadedCopyWith<VocabulariesLoaded> get copyWith => _$VocabulariesLoadedCopyWithImpl<VocabulariesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabulariesLoaded&&const DeepCollectionEquality().equals(other._vocabularies, _vocabularies));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vocabularies));

@override
String toString() {
  return 'VocabulariesState.loaded(vocabularies: $vocabularies)';
}


}

/// @nodoc
abstract mixin class $VocabulariesLoadedCopyWith<$Res> implements $VocabulariesStateCopyWith<$Res> {
  factory $VocabulariesLoadedCopyWith(VocabulariesLoaded value, $Res Function(VocabulariesLoaded) _then) = _$VocabulariesLoadedCopyWithImpl;
@useResult
$Res call({
 List<Vocabulary> vocabularies
});




}
/// @nodoc
class _$VocabulariesLoadedCopyWithImpl<$Res>
    implements $VocabulariesLoadedCopyWith<$Res> {
  _$VocabulariesLoadedCopyWithImpl(this._self, this._then);

  final VocabulariesLoaded _self;
  final $Res Function(VocabulariesLoaded) _then;

/// Create a copy of VocabulariesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? vocabularies = null,}) {
  return _then(VocabulariesLoaded(
null == vocabularies ? _self._vocabularies : vocabularies // ignore: cast_nullable_to_non_nullable
as List<Vocabulary>,
  ));
}


}

/// @nodoc


class VocabulariesError implements VocabulariesState {
  const VocabulariesError(this.message);
  

 final  String message;

/// Create a copy of VocabulariesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabulariesErrorCopyWith<VocabulariesError> get copyWith => _$VocabulariesErrorCopyWithImpl<VocabulariesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabulariesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'VocabulariesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $VocabulariesErrorCopyWith<$Res> implements $VocabulariesStateCopyWith<$Res> {
  factory $VocabulariesErrorCopyWith(VocabulariesError value, $Res Function(VocabulariesError) _then) = _$VocabulariesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$VocabulariesErrorCopyWithImpl<$Res>
    implements $VocabulariesErrorCopyWith<$Res> {
  _$VocabulariesErrorCopyWithImpl(this._self, this._then);

  final VocabulariesError _self;
  final $Res Function(VocabulariesError) _then;

/// Create a copy of VocabulariesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(VocabulariesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PhrasesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhrasesState()';
}


}

/// @nodoc
class $PhrasesStateCopyWith<$Res>  {
$PhrasesStateCopyWith(PhrasesState _, $Res Function(PhrasesState) __);
}


/// Adds pattern-matching-related methods to [PhrasesState].
extension PhrasesStatePatterns on PhrasesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PhrasesInitial value)?  initial,TResult Function( PhrasesLoading value)?  loading,TResult Function( PhrasesLoaded value)?  loaded,TResult Function( PhrasesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PhrasesInitial() when initial != null:
return initial(_that);case PhrasesLoading() when loading != null:
return loading(_that);case PhrasesLoaded() when loaded != null:
return loaded(_that);case PhrasesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PhrasesInitial value)  initial,required TResult Function( PhrasesLoading value)  loading,required TResult Function( PhrasesLoaded value)  loaded,required TResult Function( PhrasesError value)  error,}){
final _that = this;
switch (_that) {
case PhrasesInitial():
return initial(_that);case PhrasesLoading():
return loading(_that);case PhrasesLoaded():
return loaded(_that);case PhrasesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PhrasesInitial value)?  initial,TResult? Function( PhrasesLoading value)?  loading,TResult? Function( PhrasesLoaded value)?  loaded,TResult? Function( PhrasesError value)?  error,}){
final _that = this;
switch (_that) {
case PhrasesInitial() when initial != null:
return initial(_that);case PhrasesLoading() when loading != null:
return loading(_that);case PhrasesLoaded() when loaded != null:
return loaded(_that);case PhrasesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Phrase> phrases)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PhrasesInitial() when initial != null:
return initial();case PhrasesLoading() when loading != null:
return loading();case PhrasesLoaded() when loaded != null:
return loaded(_that.phrases);case PhrasesError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Phrase> phrases)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PhrasesInitial():
return initial();case PhrasesLoading():
return loading();case PhrasesLoaded():
return loaded(_that.phrases);case PhrasesError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Phrase> phrases)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PhrasesInitial() when initial != null:
return initial();case PhrasesLoading() when loading != null:
return loading();case PhrasesLoaded() when loaded != null:
return loaded(_that.phrases);case PhrasesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PhrasesInitial implements PhrasesState {
  const PhrasesInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhrasesState.initial()';
}


}




/// @nodoc


class PhrasesLoading implements PhrasesState {
  const PhrasesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PhrasesState.loading()';
}


}




/// @nodoc


class PhrasesLoaded implements PhrasesState {
  const PhrasesLoaded(final  List<Phrase> phrases): _phrases = phrases;
  

 final  List<Phrase> _phrases;
 List<Phrase> get phrases {
  if (_phrases is EqualUnmodifiableListView) return _phrases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phrases);
}


/// Create a copy of PhrasesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhrasesLoadedCopyWith<PhrasesLoaded> get copyWith => _$PhrasesLoadedCopyWithImpl<PhrasesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasesLoaded&&const DeepCollectionEquality().equals(other._phrases, _phrases));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_phrases));

@override
String toString() {
  return 'PhrasesState.loaded(phrases: $phrases)';
}


}

/// @nodoc
abstract mixin class $PhrasesLoadedCopyWith<$Res> implements $PhrasesStateCopyWith<$Res> {
  factory $PhrasesLoadedCopyWith(PhrasesLoaded value, $Res Function(PhrasesLoaded) _then) = _$PhrasesLoadedCopyWithImpl;
@useResult
$Res call({
 List<Phrase> phrases
});




}
/// @nodoc
class _$PhrasesLoadedCopyWithImpl<$Res>
    implements $PhrasesLoadedCopyWith<$Res> {
  _$PhrasesLoadedCopyWithImpl(this._self, this._then);

  final PhrasesLoaded _self;
  final $Res Function(PhrasesLoaded) _then;

/// Create a copy of PhrasesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phrases = null,}) {
  return _then(PhrasesLoaded(
null == phrases ? _self._phrases : phrases // ignore: cast_nullable_to_non_nullable
as List<Phrase>,
  ));
}


}

/// @nodoc


class PhrasesError implements PhrasesState {
  const PhrasesError(this.message);
  

 final  String message;

/// Create a copy of PhrasesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhrasesErrorCopyWith<PhrasesError> get copyWith => _$PhrasesErrorCopyWithImpl<PhrasesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhrasesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PhrasesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PhrasesErrorCopyWith<$Res> implements $PhrasesStateCopyWith<$Res> {
  factory $PhrasesErrorCopyWith(PhrasesError value, $Res Function(PhrasesError) _then) = _$PhrasesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PhrasesErrorCopyWithImpl<$Res>
    implements $PhrasesErrorCopyWith<$Res> {
  _$PhrasesErrorCopyWithImpl(this._self, this._then);

  final PhrasesError _self;
  final $Res Function(PhrasesError) _then;

/// Create a copy of PhrasesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PhrasesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$UserAnalyticsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnalyticsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserAnalyticsState()';
}


}

/// @nodoc
class $UserAnalyticsStateCopyWith<$Res>  {
$UserAnalyticsStateCopyWith(UserAnalyticsState _, $Res Function(UserAnalyticsState) __);
}


/// Adds pattern-matching-related methods to [UserAnalyticsState].
extension UserAnalyticsStatePatterns on UserAnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserAnalyticsInitial value)?  initial,TResult Function( UserAnalyticsLoading value)?  loading,TResult Function( UserAnalyticsLoaded value)?  loaded,TResult Function( UserAnalyticsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserAnalyticsInitial() when initial != null:
return initial(_that);case UserAnalyticsLoading() when loading != null:
return loading(_that);case UserAnalyticsLoaded() when loaded != null:
return loaded(_that);case UserAnalyticsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserAnalyticsInitial value)  initial,required TResult Function( UserAnalyticsLoading value)  loading,required TResult Function( UserAnalyticsLoaded value)  loaded,required TResult Function( UserAnalyticsError value)  error,}){
final _that = this;
switch (_that) {
case UserAnalyticsInitial():
return initial(_that);case UserAnalyticsLoading():
return loading(_that);case UserAnalyticsLoaded():
return loaded(_that);case UserAnalyticsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserAnalyticsInitial value)?  initial,TResult? Function( UserAnalyticsLoading value)?  loading,TResult? Function( UserAnalyticsLoaded value)?  loaded,TResult? Function( UserAnalyticsError value)?  error,}){
final _that = this;
switch (_that) {
case UserAnalyticsInitial() when initial != null:
return initial(_that);case UserAnalyticsLoading() when loading != null:
return loading(_that);case UserAnalyticsLoaded() when loaded != null:
return loaded(_that);case UserAnalyticsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Map<String, dynamic> analytics)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserAnalyticsInitial() when initial != null:
return initial();case UserAnalyticsLoading() when loading != null:
return loading();case UserAnalyticsLoaded() when loaded != null:
return loaded(_that.analytics);case UserAnalyticsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Map<String, dynamic> analytics)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UserAnalyticsInitial():
return initial();case UserAnalyticsLoading():
return loading();case UserAnalyticsLoaded():
return loaded(_that.analytics);case UserAnalyticsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Map<String, dynamic> analytics)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UserAnalyticsInitial() when initial != null:
return initial();case UserAnalyticsLoading() when loading != null:
return loading();case UserAnalyticsLoaded() when loaded != null:
return loaded(_that.analytics);case UserAnalyticsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UserAnalyticsInitial implements UserAnalyticsState {
  const UserAnalyticsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnalyticsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserAnalyticsState.initial()';
}


}




/// @nodoc


class UserAnalyticsLoading implements UserAnalyticsState {
  const UserAnalyticsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnalyticsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserAnalyticsState.loading()';
}


}




/// @nodoc


class UserAnalyticsLoaded implements UserAnalyticsState {
  const UserAnalyticsLoaded(final  Map<String, dynamic> analytics): _analytics = analytics;
  

 final  Map<String, dynamic> _analytics;
 Map<String, dynamic> get analytics {
  if (_analytics is EqualUnmodifiableMapView) return _analytics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_analytics);
}


/// Create a copy of UserAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAnalyticsLoadedCopyWith<UserAnalyticsLoaded> get copyWith => _$UserAnalyticsLoadedCopyWithImpl<UserAnalyticsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnalyticsLoaded&&const DeepCollectionEquality().equals(other._analytics, _analytics));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_analytics));

@override
String toString() {
  return 'UserAnalyticsState.loaded(analytics: $analytics)';
}


}

/// @nodoc
abstract mixin class $UserAnalyticsLoadedCopyWith<$Res> implements $UserAnalyticsStateCopyWith<$Res> {
  factory $UserAnalyticsLoadedCopyWith(UserAnalyticsLoaded value, $Res Function(UserAnalyticsLoaded) _then) = _$UserAnalyticsLoadedCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> analytics
});




}
/// @nodoc
class _$UserAnalyticsLoadedCopyWithImpl<$Res>
    implements $UserAnalyticsLoadedCopyWith<$Res> {
  _$UserAnalyticsLoadedCopyWithImpl(this._self, this._then);

  final UserAnalyticsLoaded _self;
  final $Res Function(UserAnalyticsLoaded) _then;

/// Create a copy of UserAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? analytics = null,}) {
  return _then(UserAnalyticsLoaded(
null == analytics ? _self._analytics : analytics // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class UserAnalyticsError implements UserAnalyticsState {
  const UserAnalyticsError(this.message);
  

 final  String message;

/// Create a copy of UserAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAnalyticsErrorCopyWith<UserAnalyticsError> get copyWith => _$UserAnalyticsErrorCopyWithImpl<UserAnalyticsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAnalyticsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserAnalyticsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UserAnalyticsErrorCopyWith<$Res> implements $UserAnalyticsStateCopyWith<$Res> {
  factory $UserAnalyticsErrorCopyWith(UserAnalyticsError value, $Res Function(UserAnalyticsError) _then) = _$UserAnalyticsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UserAnalyticsErrorCopyWithImpl<$Res>
    implements $UserAnalyticsErrorCopyWith<$Res> {
  _$UserAnalyticsErrorCopyWithImpl(this._self, this._then);

  final UserAnalyticsError _self;
  final $Res Function(UserAnalyticsError) _then;

/// Create a copy of UserAnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UserAnalyticsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$UserDataManagementState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataManagementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDataManagementState()';
}


}

/// @nodoc
class $UserDataManagementStateCopyWith<$Res>  {
$UserDataManagementStateCopyWith(UserDataManagementState _, $Res Function(UserDataManagementState) __);
}


/// Adds pattern-matching-related methods to [UserDataManagementState].
extension UserDataManagementStatePatterns on UserDataManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserDataManagementInitial value)?  initial,TResult Function( UserDataManagementLoading value)?  loading,TResult Function( UserDataManagementSuccess value)?  success,TResult Function( UserDataManagementError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserDataManagementInitial() when initial != null:
return initial(_that);case UserDataManagementLoading() when loading != null:
return loading(_that);case UserDataManagementSuccess() when success != null:
return success(_that);case UserDataManagementError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserDataManagementInitial value)  initial,required TResult Function( UserDataManagementLoading value)  loading,required TResult Function( UserDataManagementSuccess value)  success,required TResult Function( UserDataManagementError value)  error,}){
final _that = this;
switch (_that) {
case UserDataManagementInitial():
return initial(_that);case UserDataManagementLoading():
return loading(_that);case UserDataManagementSuccess():
return success(_that);case UserDataManagementError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserDataManagementInitial value)?  initial,TResult? Function( UserDataManagementLoading value)?  loading,TResult? Function( UserDataManagementSuccess value)?  success,TResult? Function( UserDataManagementError value)?  error,}){
final _that = this;
switch (_that) {
case UserDataManagementInitial() when initial != null:
return initial(_that);case UserDataManagementLoading() when loading != null:
return loading(_that);case UserDataManagementSuccess() when success != null:
return success(_that);case UserDataManagementError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserDataManagementInitial() when initial != null:
return initial();case UserDataManagementLoading() when loading != null:
return loading();case UserDataManagementSuccess() when success != null:
return success();case UserDataManagementError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UserDataManagementInitial():
return initial();case UserDataManagementLoading():
return loading();case UserDataManagementSuccess():
return success();case UserDataManagementError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UserDataManagementInitial() when initial != null:
return initial();case UserDataManagementLoading() when loading != null:
return loading();case UserDataManagementSuccess() when success != null:
return success();case UserDataManagementError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UserDataManagementInitial implements UserDataManagementState {
  const UserDataManagementInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataManagementInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDataManagementState.initial()';
}


}




/// @nodoc


class UserDataManagementLoading implements UserDataManagementState {
  const UserDataManagementLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataManagementLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDataManagementState.loading()';
}


}




/// @nodoc


class UserDataManagementSuccess implements UserDataManagementState {
  const UserDataManagementSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataManagementSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserDataManagementState.success()';
}


}




/// @nodoc


class UserDataManagementError implements UserDataManagementState {
  const UserDataManagementError(this.message);
  

 final  String message;

/// Create a copy of UserDataManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDataManagementErrorCopyWith<UserDataManagementError> get copyWith => _$UserDataManagementErrorCopyWithImpl<UserDataManagementError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDataManagementError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserDataManagementState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UserDataManagementErrorCopyWith<$Res> implements $UserDataManagementStateCopyWith<$Res> {
  factory $UserDataManagementErrorCopyWith(UserDataManagementError value, $Res Function(UserDataManagementError) _then) = _$UserDataManagementErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UserDataManagementErrorCopyWithImpl<$Res>
    implements $UserDataManagementErrorCopyWith<$Res> {
  _$UserDataManagementErrorCopyWithImpl(this._self, this._then);

  final UserDataManagementError _self;
  final $Res Function(UserDataManagementError) _then;

/// Create a copy of UserDataManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UserDataManagementError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DailyLessonsState {

 VocabulariesState get vocabularies; PhrasesState get phrases; UserAnalyticsState get analytics; UserDataManagementState get dataManagement; bool get isRefreshing;
/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyLessonsStateCopyWith<DailyLessonsState> get copyWith => _$DailyLessonsStateCopyWithImpl<DailyLessonsState>(this as DailyLessonsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLessonsState&&(identical(other.vocabularies, vocabularies) || other.vocabularies == vocabularies)&&(identical(other.phrases, phrases) || other.phrases == phrases)&&(identical(other.analytics, analytics) || other.analytics == analytics)&&(identical(other.dataManagement, dataManagement) || other.dataManagement == dataManagement)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,vocabularies,phrases,analytics,dataManagement,isRefreshing);

@override
String toString() {
  return 'DailyLessonsState(vocabularies: $vocabularies, phrases: $phrases, analytics: $analytics, dataManagement: $dataManagement, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class $DailyLessonsStateCopyWith<$Res>  {
  factory $DailyLessonsStateCopyWith(DailyLessonsState value, $Res Function(DailyLessonsState) _then) = _$DailyLessonsStateCopyWithImpl;
@useResult
$Res call({
 VocabulariesState vocabularies, PhrasesState phrases, UserAnalyticsState analytics, UserDataManagementState dataManagement, bool isRefreshing
});


$VocabulariesStateCopyWith<$Res> get vocabularies;$PhrasesStateCopyWith<$Res> get phrases;$UserAnalyticsStateCopyWith<$Res> get analytics;$UserDataManagementStateCopyWith<$Res> get dataManagement;

}
/// @nodoc
class _$DailyLessonsStateCopyWithImpl<$Res>
    implements $DailyLessonsStateCopyWith<$Res> {
  _$DailyLessonsStateCopyWithImpl(this._self, this._then);

  final DailyLessonsState _self;
  final $Res Function(DailyLessonsState) _then;

/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vocabularies = null,Object? phrases = null,Object? analytics = null,Object? dataManagement = null,Object? isRefreshing = null,}) {
  return _then(_self.copyWith(
vocabularies: null == vocabularies ? _self.vocabularies : vocabularies // ignore: cast_nullable_to_non_nullable
as VocabulariesState,phrases: null == phrases ? _self.phrases : phrases // ignore: cast_nullable_to_non_nullable
as PhrasesState,analytics: null == analytics ? _self.analytics : analytics // ignore: cast_nullable_to_non_nullable
as UserAnalyticsState,dataManagement: null == dataManagement ? _self.dataManagement : dataManagement // ignore: cast_nullable_to_non_nullable
as UserDataManagementState,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VocabulariesStateCopyWith<$Res> get vocabularies {
  
  return $VocabulariesStateCopyWith<$Res>(_self.vocabularies, (value) {
    return _then(_self.copyWith(vocabularies: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhrasesStateCopyWith<$Res> get phrases {
  
  return $PhrasesStateCopyWith<$Res>(_self.phrases, (value) {
    return _then(_self.copyWith(phrases: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAnalyticsStateCopyWith<$Res> get analytics {
  
  return $UserAnalyticsStateCopyWith<$Res>(_self.analytics, (value) {
    return _then(_self.copyWith(analytics: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataManagementStateCopyWith<$Res> get dataManagement {
  
  return $UserDataManagementStateCopyWith<$Res>(_self.dataManagement, (value) {
    return _then(_self.copyWith(dataManagement: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyLessonsState].
extension DailyLessonsStatePatterns on DailyLessonsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyLessonsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyLessonsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyLessonsState value)  $default,){
final _that = this;
switch (_that) {
case _DailyLessonsState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyLessonsState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyLessonsState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VocabulariesState vocabularies,  PhrasesState phrases,  UserAnalyticsState analytics,  UserDataManagementState dataManagement,  bool isRefreshing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyLessonsState() when $default != null:
return $default(_that.vocabularies,_that.phrases,_that.analytics,_that.dataManagement,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VocabulariesState vocabularies,  PhrasesState phrases,  UserAnalyticsState analytics,  UserDataManagementState dataManagement,  bool isRefreshing)  $default,) {final _that = this;
switch (_that) {
case _DailyLessonsState():
return $default(_that.vocabularies,_that.phrases,_that.analytics,_that.dataManagement,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VocabulariesState vocabularies,  PhrasesState phrases,  UserAnalyticsState analytics,  UserDataManagementState dataManagement,  bool isRefreshing)?  $default,) {final _that = this;
switch (_that) {
case _DailyLessonsState() when $default != null:
return $default(_that.vocabularies,_that.phrases,_that.analytics,_that.dataManagement,_that.isRefreshing);case _:
  return null;

}
}

}

/// @nodoc


class _DailyLessonsState implements DailyLessonsState {
  const _DailyLessonsState({required this.vocabularies, required this.phrases, required this.analytics, required this.dataManagement, this.isRefreshing = false});
  

@override final  VocabulariesState vocabularies;
@override final  PhrasesState phrases;
@override final  UserAnalyticsState analytics;
@override final  UserDataManagementState dataManagement;
@override@JsonKey() final  bool isRefreshing;

/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyLessonsStateCopyWith<_DailyLessonsState> get copyWith => __$DailyLessonsStateCopyWithImpl<_DailyLessonsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyLessonsState&&(identical(other.vocabularies, vocabularies) || other.vocabularies == vocabularies)&&(identical(other.phrases, phrases) || other.phrases == phrases)&&(identical(other.analytics, analytics) || other.analytics == analytics)&&(identical(other.dataManagement, dataManagement) || other.dataManagement == dataManagement)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,vocabularies,phrases,analytics,dataManagement,isRefreshing);

@override
String toString() {
  return 'DailyLessonsState(vocabularies: $vocabularies, phrases: $phrases, analytics: $analytics, dataManagement: $dataManagement, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class _$DailyLessonsStateCopyWith<$Res> implements $DailyLessonsStateCopyWith<$Res> {
  factory _$DailyLessonsStateCopyWith(_DailyLessonsState value, $Res Function(_DailyLessonsState) _then) = __$DailyLessonsStateCopyWithImpl;
@override @useResult
$Res call({
 VocabulariesState vocabularies, PhrasesState phrases, UserAnalyticsState analytics, UserDataManagementState dataManagement, bool isRefreshing
});


@override $VocabulariesStateCopyWith<$Res> get vocabularies;@override $PhrasesStateCopyWith<$Res> get phrases;@override $UserAnalyticsStateCopyWith<$Res> get analytics;@override $UserDataManagementStateCopyWith<$Res> get dataManagement;

}
/// @nodoc
class __$DailyLessonsStateCopyWithImpl<$Res>
    implements _$DailyLessonsStateCopyWith<$Res> {
  __$DailyLessonsStateCopyWithImpl(this._self, this._then);

  final _DailyLessonsState _self;
  final $Res Function(_DailyLessonsState) _then;

/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vocabularies = null,Object? phrases = null,Object? analytics = null,Object? dataManagement = null,Object? isRefreshing = null,}) {
  return _then(_DailyLessonsState(
vocabularies: null == vocabularies ? _self.vocabularies : vocabularies // ignore: cast_nullable_to_non_nullable
as VocabulariesState,phrases: null == phrases ? _self.phrases : phrases // ignore: cast_nullable_to_non_nullable
as PhrasesState,analytics: null == analytics ? _self.analytics : analytics // ignore: cast_nullable_to_non_nullable
as UserAnalyticsState,dataManagement: null == dataManagement ? _self.dataManagement : dataManagement // ignore: cast_nullable_to_non_nullable
as UserDataManagementState,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VocabulariesStateCopyWith<$Res> get vocabularies {
  
  return $VocabulariesStateCopyWith<$Res>(_self.vocabularies, (value) {
    return _then(_self.copyWith(vocabularies: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhrasesStateCopyWith<$Res> get phrases {
  
  return $PhrasesStateCopyWith<$Res>(_self.phrases, (value) {
    return _then(_self.copyWith(phrases: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAnalyticsStateCopyWith<$Res> get analytics {
  
  return $UserAnalyticsStateCopyWith<$Res>(_self.analytics, (value) {
    return _then(_self.copyWith(analytics: value));
  });
}/// Create a copy of DailyLessonsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDataManagementStateCopyWith<$Res> get dataManagement {
  
  return $UserDataManagementStateCopyWith<$Res>(_self.dataManagement, (value) {
    return _then(_self.copyWith(dataManagement: value));
  });
}
}

// dart format on
