// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent()';
}


}

/// @nodoc
class $AuthenticationEventCopyWith<$Res>  {
$AuthenticationEventCopyWith(AuthenticationEvent _, $Res Function(AuthenticationEvent) __);
}


/// Adds pattern-matching-related methods to [AuthenticationEvent].
extension AuthenticationEventPatterns on AuthenticationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GoogleSignIn value)?  googleSignIn,TResult Function( CheckLoginStatus value)?  checkLoginStatus,TResult Function( SignOut value)?  signOut,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GoogleSignIn() when googleSignIn != null:
return googleSignIn(_that);case CheckLoginStatus() when checkLoginStatus != null:
return checkLoginStatus(_that);case SignOut() when signOut != null:
return signOut(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GoogleSignIn value)  googleSignIn,required TResult Function( CheckLoginStatus value)  checkLoginStatus,required TResult Function( SignOut value)  signOut,}){
final _that = this;
switch (_that) {
case GoogleSignIn():
return googleSignIn(_that);case CheckLoginStatus():
return checkLoginStatus(_that);case SignOut():
return signOut(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GoogleSignIn value)?  googleSignIn,TResult? Function( CheckLoginStatus value)?  checkLoginStatus,TResult? Function( SignOut value)?  signOut,}){
final _that = this;
switch (_that) {
case GoogleSignIn() when googleSignIn != null:
return googleSignIn(_that);case CheckLoginStatus() when checkLoginStatus != null:
return checkLoginStatus(_that);case SignOut() when signOut != null:
return signOut(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  googleSignIn,TResult Function()?  checkLoginStatus,TResult Function()?  signOut,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GoogleSignIn() when googleSignIn != null:
return googleSignIn();case CheckLoginStatus() when checkLoginStatus != null:
return checkLoginStatus();case SignOut() when signOut != null:
return signOut();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  googleSignIn,required TResult Function()  checkLoginStatus,required TResult Function()  signOut,}) {final _that = this;
switch (_that) {
case GoogleSignIn():
return googleSignIn();case CheckLoginStatus():
return checkLoginStatus();case SignOut():
return signOut();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  googleSignIn,TResult? Function()?  checkLoginStatus,TResult? Function()?  signOut,}) {final _that = this;
switch (_that) {
case GoogleSignIn() when googleSignIn != null:
return googleSignIn();case CheckLoginStatus() when checkLoginStatus != null:
return checkLoginStatus();case SignOut() when signOut != null:
return signOut();case _:
  return null;

}
}

}

/// @nodoc


class GoogleSignIn implements AuthenticationEvent {
  const GoogleSignIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.googleSignIn()';
}


}




/// @nodoc


class CheckLoginStatus implements AuthenticationEvent {
  const CheckLoginStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckLoginStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.checkLoginStatus()';
}


}




/// @nodoc


class SignOut implements AuthenticationEvent {
  const SignOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.signOut()';
}


}




// dart format on
