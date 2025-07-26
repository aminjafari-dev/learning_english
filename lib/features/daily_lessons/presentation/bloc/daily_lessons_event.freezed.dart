// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_lessons_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyLessonsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLessonsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent()';
}


}

/// @nodoc
class $DailyLessonsEventCopyWith<$Res>  {
$DailyLessonsEventCopyWith(DailyLessonsEvent _, $Res Function(DailyLessonsEvent) __);
}


/// Adds pattern-matching-related methods to [DailyLessonsEvent].
extension DailyLessonsEventPatterns on DailyLessonsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FetchVocabularies value)?  fetchVocabularies,TResult Function( FetchPhrases value)?  fetchPhrases,TResult Function( FetchLessons value)?  fetchLessons,TResult Function( RefreshLessons value)?  refreshLessons,TResult Function( MarkVocabularyAsUsed value)?  markVocabularyAsUsed,TResult Function( MarkPhraseAsUsed value)?  markPhraseAsUsed,TResult Function( GetUserAnalytics value)?  getUserAnalytics,TResult Function( ClearUserData value)?  clearUserData,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies(_that);case FetchPhrases() when fetchPhrases != null:
return fetchPhrases(_that);case FetchLessons() when fetchLessons != null:
return fetchLessons(_that);case RefreshLessons() when refreshLessons != null:
return refreshLessons(_that);case MarkVocabularyAsUsed() when markVocabularyAsUsed != null:
return markVocabularyAsUsed(_that);case MarkPhraseAsUsed() when markPhraseAsUsed != null:
return markPhraseAsUsed(_that);case GetUserAnalytics() when getUserAnalytics != null:
return getUserAnalytics(_that);case ClearUserData() when clearUserData != null:
return clearUserData(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FetchVocabularies value)  fetchVocabularies,required TResult Function( FetchPhrases value)  fetchPhrases,required TResult Function( FetchLessons value)  fetchLessons,required TResult Function( RefreshLessons value)  refreshLessons,required TResult Function( MarkVocabularyAsUsed value)  markVocabularyAsUsed,required TResult Function( MarkPhraseAsUsed value)  markPhraseAsUsed,required TResult Function( GetUserAnalytics value)  getUserAnalytics,required TResult Function( ClearUserData value)  clearUserData,}){
final _that = this;
switch (_that) {
case FetchVocabularies():
return fetchVocabularies(_that);case FetchPhrases():
return fetchPhrases(_that);case FetchLessons():
return fetchLessons(_that);case RefreshLessons():
return refreshLessons(_that);case MarkVocabularyAsUsed():
return markVocabularyAsUsed(_that);case MarkPhraseAsUsed():
return markPhraseAsUsed(_that);case GetUserAnalytics():
return getUserAnalytics(_that);case ClearUserData():
return clearUserData(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FetchVocabularies value)?  fetchVocabularies,TResult? Function( FetchPhrases value)?  fetchPhrases,TResult? Function( FetchLessons value)?  fetchLessons,TResult? Function( RefreshLessons value)?  refreshLessons,TResult? Function( MarkVocabularyAsUsed value)?  markVocabularyAsUsed,TResult? Function( MarkPhraseAsUsed value)?  markPhraseAsUsed,TResult? Function( GetUserAnalytics value)?  getUserAnalytics,TResult? Function( ClearUserData value)?  clearUserData,}){
final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies(_that);case FetchPhrases() when fetchPhrases != null:
return fetchPhrases(_that);case FetchLessons() when fetchLessons != null:
return fetchLessons(_that);case RefreshLessons() when refreshLessons != null:
return refreshLessons(_that);case MarkVocabularyAsUsed() when markVocabularyAsUsed != null:
return markVocabularyAsUsed(_that);case MarkPhraseAsUsed() when markPhraseAsUsed != null:
return markPhraseAsUsed(_that);case GetUserAnalytics() when getUserAnalytics != null:
return getUserAnalytics(_that);case ClearUserData() when clearUserData != null:
return clearUserData(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchVocabularies,TResult Function()?  fetchPhrases,TResult Function()?  fetchLessons,TResult Function()?  refreshLessons,TResult Function( String english)?  markVocabularyAsUsed,TResult Function( String english)?  markPhraseAsUsed,TResult Function()?  getUserAnalytics,TResult Function()?  clearUserData,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies();case FetchPhrases() when fetchPhrases != null:
return fetchPhrases();case FetchLessons() when fetchLessons != null:
return fetchLessons();case RefreshLessons() when refreshLessons != null:
return refreshLessons();case MarkVocabularyAsUsed() when markVocabularyAsUsed != null:
return markVocabularyAsUsed(_that.english);case MarkPhraseAsUsed() when markPhraseAsUsed != null:
return markPhraseAsUsed(_that.english);case GetUserAnalytics() when getUserAnalytics != null:
return getUserAnalytics();case ClearUserData() when clearUserData != null:
return clearUserData();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchVocabularies,required TResult Function()  fetchPhrases,required TResult Function()  fetchLessons,required TResult Function()  refreshLessons,required TResult Function( String english)  markVocabularyAsUsed,required TResult Function( String english)  markPhraseAsUsed,required TResult Function()  getUserAnalytics,required TResult Function()  clearUserData,}) {final _that = this;
switch (_that) {
case FetchVocabularies():
return fetchVocabularies();case FetchPhrases():
return fetchPhrases();case FetchLessons():
return fetchLessons();case RefreshLessons():
return refreshLessons();case MarkVocabularyAsUsed():
return markVocabularyAsUsed(_that.english);case MarkPhraseAsUsed():
return markPhraseAsUsed(_that.english);case GetUserAnalytics():
return getUserAnalytics();case ClearUserData():
return clearUserData();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchVocabularies,TResult? Function()?  fetchPhrases,TResult? Function()?  fetchLessons,TResult? Function()?  refreshLessons,TResult? Function( String english)?  markVocabularyAsUsed,TResult? Function( String english)?  markPhraseAsUsed,TResult? Function()?  getUserAnalytics,TResult? Function()?  clearUserData,}) {final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies();case FetchPhrases() when fetchPhrases != null:
return fetchPhrases();case FetchLessons() when fetchLessons != null:
return fetchLessons();case RefreshLessons() when refreshLessons != null:
return refreshLessons();case MarkVocabularyAsUsed() when markVocabularyAsUsed != null:
return markVocabularyAsUsed(_that.english);case MarkPhraseAsUsed() when markPhraseAsUsed != null:
return markPhraseAsUsed(_that.english);case GetUserAnalytics() when getUserAnalytics != null:
return getUserAnalytics();case ClearUserData() when clearUserData != null:
return clearUserData();case _:
  return null;

}
}

}

/// @nodoc


class FetchVocabularies implements DailyLessonsEvent {
  const FetchVocabularies();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchVocabularies);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.fetchVocabularies()';
}


}




/// @nodoc


class FetchPhrases implements DailyLessonsEvent {
  const FetchPhrases();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchPhrases);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.fetchPhrases()';
}


}




/// @nodoc


class FetchLessons implements DailyLessonsEvent {
  const FetchLessons();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchLessons);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.fetchLessons()';
}


}




/// @nodoc


class RefreshLessons implements DailyLessonsEvent {
  const RefreshLessons();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshLessons);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.refreshLessons()';
}


}




/// @nodoc


class MarkVocabularyAsUsed implements DailyLessonsEvent {
  const MarkVocabularyAsUsed({required this.english});
  

 final  String english;

/// Create a copy of DailyLessonsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkVocabularyAsUsedCopyWith<MarkVocabularyAsUsed> get copyWith => _$MarkVocabularyAsUsedCopyWithImpl<MarkVocabularyAsUsed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkVocabularyAsUsed&&(identical(other.english, english) || other.english == english));
}


@override
int get hashCode => Object.hash(runtimeType,english);

@override
String toString() {
  return 'DailyLessonsEvent.markVocabularyAsUsed(english: $english)';
}


}

/// @nodoc
abstract mixin class $MarkVocabularyAsUsedCopyWith<$Res> implements $DailyLessonsEventCopyWith<$Res> {
  factory $MarkVocabularyAsUsedCopyWith(MarkVocabularyAsUsed value, $Res Function(MarkVocabularyAsUsed) _then) = _$MarkVocabularyAsUsedCopyWithImpl;
@useResult
$Res call({
 String english
});




}
/// @nodoc
class _$MarkVocabularyAsUsedCopyWithImpl<$Res>
    implements $MarkVocabularyAsUsedCopyWith<$Res> {
  _$MarkVocabularyAsUsedCopyWithImpl(this._self, this._then);

  final MarkVocabularyAsUsed _self;
  final $Res Function(MarkVocabularyAsUsed) _then;

/// Create a copy of DailyLessonsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? english = null,}) {
  return _then(MarkVocabularyAsUsed(
english: null == english ? _self.english : english // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MarkPhraseAsUsed implements DailyLessonsEvent {
  const MarkPhraseAsUsed({required this.english});
  

 final  String english;

/// Create a copy of DailyLessonsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkPhraseAsUsedCopyWith<MarkPhraseAsUsed> get copyWith => _$MarkPhraseAsUsedCopyWithImpl<MarkPhraseAsUsed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkPhraseAsUsed&&(identical(other.english, english) || other.english == english));
}


@override
int get hashCode => Object.hash(runtimeType,english);

@override
String toString() {
  return 'DailyLessonsEvent.markPhraseAsUsed(english: $english)';
}


}

/// @nodoc
abstract mixin class $MarkPhraseAsUsedCopyWith<$Res> implements $DailyLessonsEventCopyWith<$Res> {
  factory $MarkPhraseAsUsedCopyWith(MarkPhraseAsUsed value, $Res Function(MarkPhraseAsUsed) _then) = _$MarkPhraseAsUsedCopyWithImpl;
@useResult
$Res call({
 String english
});




}
/// @nodoc
class _$MarkPhraseAsUsedCopyWithImpl<$Res>
    implements $MarkPhraseAsUsedCopyWith<$Res> {
  _$MarkPhraseAsUsedCopyWithImpl(this._self, this._then);

  final MarkPhraseAsUsed _self;
  final $Res Function(MarkPhraseAsUsed) _then;

/// Create a copy of DailyLessonsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? english = null,}) {
  return _then(MarkPhraseAsUsed(
english: null == english ? _self.english : english // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GetUserAnalytics implements DailyLessonsEvent {
  const GetUserAnalytics();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetUserAnalytics);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.getUserAnalytics()';
}


}




/// @nodoc


class ClearUserData implements DailyLessonsEvent {
  const ClearUserData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearUserData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLessonsEvent.clearUserData()';
}


}




// dart format on
