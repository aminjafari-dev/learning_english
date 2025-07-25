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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FetchVocabularies value)?  fetchVocabularies,TResult Function( FetchPhrases value)?  fetchPhrases,TResult Function( FetchLessons value)?  fetchLessons,TResult Function( RefreshLessons value)?  refreshLessons,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies(_that);case FetchPhrases() when fetchPhrases != null:
return fetchPhrases(_that);case FetchLessons() when fetchLessons != null:
return fetchLessons(_that);case RefreshLessons() when refreshLessons != null:
return refreshLessons(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FetchVocabularies value)  fetchVocabularies,required TResult Function( FetchPhrases value)  fetchPhrases,required TResult Function( FetchLessons value)  fetchLessons,required TResult Function( RefreshLessons value)  refreshLessons,}){
final _that = this;
switch (_that) {
case FetchVocabularies():
return fetchVocabularies(_that);case FetchPhrases():
return fetchPhrases(_that);case FetchLessons():
return fetchLessons(_that);case RefreshLessons():
return refreshLessons(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FetchVocabularies value)?  fetchVocabularies,TResult? Function( FetchPhrases value)?  fetchPhrases,TResult? Function( FetchLessons value)?  fetchLessons,TResult? Function( RefreshLessons value)?  refreshLessons,}){
final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies(_that);case FetchPhrases() when fetchPhrases != null:
return fetchPhrases(_that);case FetchLessons() when fetchLessons != null:
return fetchLessons(_that);case RefreshLessons() when refreshLessons != null:
return refreshLessons(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchVocabularies,TResult Function()?  fetchPhrases,TResult Function()?  fetchLessons,TResult Function()?  refreshLessons,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies();case FetchPhrases() when fetchPhrases != null:
return fetchPhrases();case FetchLessons() when fetchLessons != null:
return fetchLessons();case RefreshLessons() when refreshLessons != null:
return refreshLessons();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchVocabularies,required TResult Function()  fetchPhrases,required TResult Function()  fetchLessons,required TResult Function()  refreshLessons,}) {final _that = this;
switch (_that) {
case FetchVocabularies():
return fetchVocabularies();case FetchPhrases():
return fetchPhrases();case FetchLessons():
return fetchLessons();case RefreshLessons():
return refreshLessons();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchVocabularies,TResult? Function()?  fetchPhrases,TResult? Function()?  fetchLessons,TResult? Function()?  refreshLessons,}) {final _that = this;
switch (_that) {
case FetchVocabularies() when fetchVocabularies != null:
return fetchVocabularies();case FetchPhrases() when fetchPhrases != null:
return fetchPhrases();case FetchLessons() when fetchLessons != null:
return fetchLessons();case RefreshLessons() when refreshLessons != null:
return refreshLessons();case _:
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




// dart format on
