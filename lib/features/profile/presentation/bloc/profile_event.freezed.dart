// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileEventCopyWith<$Res> {
  factory $ProfileEventCopyWith(
          ProfileEvent value, $Res Function(ProfileEvent) then) =
      _$ProfileEventCopyWithImpl<$Res, ProfileEvent>;
}

/// @nodoc
class _$ProfileEventCopyWithImpl<$Res, $Val extends ProfileEvent>
    implements $ProfileEventCopyWith<$Res> {
  _$ProfileEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadProfileImplCopyWith<$Res> {
  factory _$$LoadProfileImplCopyWith(
          _$LoadProfileImpl value, $Res Function(_$LoadProfileImpl) then) =
      __$$LoadProfileImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadProfileImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$LoadProfileImpl>
    implements _$$LoadProfileImplCopyWith<$Res> {
  __$$LoadProfileImplCopyWithImpl(
      _$LoadProfileImpl _value, $Res Function(_$LoadProfileImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadProfileImpl implements LoadProfile {
  const _$LoadProfileImpl();

  @override
  String toString() {
    return 'ProfileEvent.loadProfile()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadProfileImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return loadProfile();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return loadProfile?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (loadProfile != null) {
      return loadProfile();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return loadProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return loadProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (loadProfile != null) {
      return loadProfile(this);
    }
    return orElse();
  }
}

abstract class LoadProfile implements ProfileEvent {
  const factory LoadProfile() = _$LoadProfileImpl;
}

/// @nodoc
abstract class _$$UpdateProfileImplCopyWith<$Res> {
  factory _$$UpdateProfileImplCopyWith(
          _$UpdateProfileImpl value, $Res Function(_$UpdateProfileImpl) then) =
      __$$UpdateProfileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserProfileEntity profile});
}

/// @nodoc
class __$$UpdateProfileImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$UpdateProfileImpl>
    implements _$$UpdateProfileImplCopyWith<$Res> {
  __$$UpdateProfileImplCopyWithImpl(
      _$UpdateProfileImpl _value, $Res Function(_$UpdateProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
  }) {
    return _then(_$UpdateProfileImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileEntity,
    ));
  }
}

/// @nodoc

class _$UpdateProfileImpl implements UpdateProfile {
  const _$UpdateProfileImpl({required this.profile});

  @override
  final UserProfileEntity profile;

  @override
  String toString() {
    return 'ProfileEvent.updateProfile(profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileImpl &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileImplCopyWith<_$UpdateProfileImpl> get copyWith =>
      __$$UpdateProfileImplCopyWithImpl<_$UpdateProfileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return updateProfile(profile);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return updateProfile?.call(profile);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (updateProfile != null) {
      return updateProfile(profile);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return updateProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return updateProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (updateProfile != null) {
      return updateProfile(this);
    }
    return orElse();
  }
}

abstract class UpdateProfile implements ProfileEvent {
  const factory UpdateProfile({required final UserProfileEntity profile}) =
      _$UpdateProfileImpl;

  UserProfileEntity get profile;
  @JsonKey(ignore: true)
  _$$UpdateProfileImplCopyWith<_$UpdateProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateProfileImageImplCopyWith<$Res> {
  factory _$$UpdateProfileImageImplCopyWith(_$UpdateProfileImageImpl value,
          $Res Function(_$UpdateProfileImageImpl) then) =
      __$$UpdateProfileImageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String imagePath});
}

/// @nodoc
class __$$UpdateProfileImageImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$UpdateProfileImageImpl>
    implements _$$UpdateProfileImageImplCopyWith<$Res> {
  __$$UpdateProfileImageImplCopyWithImpl(_$UpdateProfileImageImpl _value,
      $Res Function(_$UpdateProfileImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? imagePath = null,
  }) {
    return _then(_$UpdateProfileImageImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateProfileImageImpl implements UpdateProfileImage {
  const _$UpdateProfileImageImpl(
      {required this.userId, required this.imagePath});

  @override
  final String userId;
  @override
  final String imagePath;

  @override
  String toString() {
    return 'ProfileEvent.updateProfileImage(userId: $userId, imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileImageImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, imagePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileImageImplCopyWith<_$UpdateProfileImageImpl> get copyWith =>
      __$$UpdateProfileImageImplCopyWithImpl<_$UpdateProfileImageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return updateProfileImage(userId, imagePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return updateProfileImage?.call(userId, imagePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (updateProfileImage != null) {
      return updateProfileImage(userId, imagePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return updateProfileImage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return updateProfileImage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (updateProfileImage != null) {
      return updateProfileImage(this);
    }
    return orElse();
  }
}

abstract class UpdateProfileImage implements ProfileEvent {
  const factory UpdateProfileImage(
      {required final String userId,
      required final String imagePath}) = _$UpdateProfileImageImpl;

  String get userId;
  String get imagePath;
  @JsonKey(ignore: true)
  _$$UpdateProfileImageImplCopyWith<_$UpdateProfileImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateAppLanguageImplCopyWith<$Res> {
  factory _$$UpdateAppLanguageImplCopyWith(_$UpdateAppLanguageImpl value,
          $Res Function(_$UpdateAppLanguageImpl) then) =
      __$$UpdateAppLanguageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String language});
}

/// @nodoc
class __$$UpdateAppLanguageImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$UpdateAppLanguageImpl>
    implements _$$UpdateAppLanguageImplCopyWith<$Res> {
  __$$UpdateAppLanguageImplCopyWithImpl(_$UpdateAppLanguageImpl _value,
      $Res Function(_$UpdateAppLanguageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? language = null,
  }) {
    return _then(_$UpdateAppLanguageImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpdateAppLanguageImpl implements UpdateAppLanguage {
  const _$UpdateAppLanguageImpl({required this.userId, required this.language});

  @override
  final String userId;
  @override
  final String language;

  @override
  String toString() {
    return 'ProfileEvent.updateAppLanguage(userId: $userId, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAppLanguageImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, language);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAppLanguageImplCopyWith<_$UpdateAppLanguageImpl> get copyWith =>
      __$$UpdateAppLanguageImplCopyWithImpl<_$UpdateAppLanguageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return updateAppLanguage(userId, language);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return updateAppLanguage?.call(userId, language);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (updateAppLanguage != null) {
      return updateAppLanguage(userId, language);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return updateAppLanguage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return updateAppLanguage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (updateAppLanguage != null) {
      return updateAppLanguage(this);
    }
    return orElse();
  }
}

abstract class UpdateAppLanguage implements ProfileEvent {
  const factory UpdateAppLanguage(
      {required final String userId,
      required final String language}) = _$UpdateAppLanguageImpl;

  String get userId;
  String get language;
  @JsonKey(ignore: true)
  _$$UpdateAppLanguageImplCopyWith<_$UpdateAppLanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveChangesImplCopyWith<$Res> {
  factory _$$SaveChangesImplCopyWith(
          _$SaveChangesImpl value, $Res Function(_$SaveChangesImpl) then) =
      __$$SaveChangesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserProfileEntity profile});
}

/// @nodoc
class __$$SaveChangesImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$SaveChangesImpl>
    implements _$$SaveChangesImplCopyWith<$Res> {
  __$$SaveChangesImplCopyWithImpl(
      _$SaveChangesImpl _value, $Res Function(_$SaveChangesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
  }) {
    return _then(_$SaveChangesImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileEntity,
    ));
  }
}

/// @nodoc

class _$SaveChangesImpl implements SaveChanges {
  const _$SaveChangesImpl({required this.profile});

  @override
  final UserProfileEntity profile;

  @override
  String toString() {
    return 'ProfileEvent.saveChanges(profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveChangesImpl &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveChangesImplCopyWith<_$SaveChangesImpl> get copyWith =>
      __$$SaveChangesImplCopyWithImpl<_$SaveChangesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return saveChanges(profile);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return saveChanges?.call(profile);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (saveChanges != null) {
      return saveChanges(profile);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return saveChanges(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return saveChanges?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (saveChanges != null) {
      return saveChanges(this);
    }
    return orElse();
  }
}

abstract class SaveChanges implements ProfileEvent {
  const factory SaveChanges({required final UserProfileEntity profile}) =
      _$SaveChangesImpl;

  UserProfileEntity get profile;
  @JsonKey(ignore: true)
  _$$SaveChangesImplCopyWith<_$SaveChangesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetImplCopyWith<$Res> {
  factory _$$ResetImplCopyWith(
          _$ResetImpl value, $Res Function(_$ResetImpl) then) =
      __$$ResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetImplCopyWithImpl<$Res>
    extends _$ProfileEventCopyWithImpl<$Res, _$ResetImpl>
    implements _$$ResetImplCopyWith<$Res> {
  __$$ResetImplCopyWithImpl(
      _$ResetImpl _value, $Res Function(_$ResetImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResetImpl implements Reset {
  const _$ResetImpl();

  @override
  String toString() {
    return 'ProfileEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadProfile,
    required TResult Function(UserProfileEntity profile) updateProfile,
    required TResult Function(String userId, String imagePath)
        updateProfileImage,
    required TResult Function(String userId, String language) updateAppLanguage,
    required TResult Function(UserProfileEntity profile) saveChanges,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadProfile,
    TResult? Function(UserProfileEntity profile)? updateProfile,
    TResult? Function(String userId, String imagePath)? updateProfileImage,
    TResult? Function(String userId, String language)? updateAppLanguage,
    TResult? Function(UserProfileEntity profile)? saveChanges,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadProfile,
    TResult Function(UserProfileEntity profile)? updateProfile,
    TResult Function(String userId, String imagePath)? updateProfileImage,
    TResult Function(String userId, String language)? updateAppLanguage,
    TResult Function(UserProfileEntity profile)? saveChanges,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadProfile value) loadProfile,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(UpdateProfileImage value) updateProfileImage,
    required TResult Function(UpdateAppLanguage value) updateAppLanguage,
    required TResult Function(SaveChanges value) saveChanges,
    required TResult Function(Reset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadProfile value)? loadProfile,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(UpdateProfileImage value)? updateProfileImage,
    TResult? Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult? Function(SaveChanges value)? saveChanges,
    TResult? Function(Reset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadProfile value)? loadProfile,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(UpdateProfileImage value)? updateProfileImage,
    TResult Function(UpdateAppLanguage value)? updateAppLanguage,
    TResult Function(SaveChanges value)? saveChanges,
    TResult Function(Reset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class Reset implements ProfileEvent {
  const factory Reset() = _$ResetImpl;
}
