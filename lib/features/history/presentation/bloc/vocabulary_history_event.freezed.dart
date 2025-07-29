// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_history_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VocabularyHistoryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistoryRequests,
    required TResult Function(String requestId) loadRequestDetails,
    required TResult Function() refreshHistory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistoryRequests,
    TResult? Function(String requestId)? loadRequestDetails,
    TResult? Function()? refreshHistory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistoryRequests,
    TResult Function(String requestId)? loadRequestDetails,
    TResult Function()? refreshHistory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistoryRequests value) loadHistoryRequests,
    required TResult Function(LoadRequestDetails value) loadRequestDetails,
    required TResult Function(RefreshHistory value) refreshHistory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult? Function(LoadRequestDetails value)? loadRequestDetails,
    TResult? Function(RefreshHistory value)? refreshHistory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult Function(LoadRequestDetails value)? loadRequestDetails,
    TResult Function(RefreshHistory value)? refreshHistory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabularyHistoryEventCopyWith<$Res> {
  factory $VocabularyHistoryEventCopyWith(VocabularyHistoryEvent value,
          $Res Function(VocabularyHistoryEvent) then) =
      _$VocabularyHistoryEventCopyWithImpl<$Res, VocabularyHistoryEvent>;
}

/// @nodoc
class _$VocabularyHistoryEventCopyWithImpl<$Res,
        $Val extends VocabularyHistoryEvent>
    implements $VocabularyHistoryEventCopyWith<$Res> {
  _$VocabularyHistoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadHistoryRequestsImplCopyWith<$Res> {
  factory _$$LoadHistoryRequestsImplCopyWith(_$LoadHistoryRequestsImpl value,
          $Res Function(_$LoadHistoryRequestsImpl) then) =
      __$$LoadHistoryRequestsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadHistoryRequestsImplCopyWithImpl<$Res>
    extends _$VocabularyHistoryEventCopyWithImpl<$Res,
        _$LoadHistoryRequestsImpl>
    implements _$$LoadHistoryRequestsImplCopyWith<$Res> {
  __$$LoadHistoryRequestsImplCopyWithImpl(_$LoadHistoryRequestsImpl _value,
      $Res Function(_$LoadHistoryRequestsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadHistoryRequestsImpl implements LoadHistoryRequests {
  const _$LoadHistoryRequestsImpl();

  @override
  String toString() {
    return 'VocabularyHistoryEvent.loadHistoryRequests()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadHistoryRequestsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistoryRequests,
    required TResult Function(String requestId) loadRequestDetails,
    required TResult Function() refreshHistory,
  }) {
    return loadHistoryRequests();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistoryRequests,
    TResult? Function(String requestId)? loadRequestDetails,
    TResult? Function()? refreshHistory,
  }) {
    return loadHistoryRequests?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistoryRequests,
    TResult Function(String requestId)? loadRequestDetails,
    TResult Function()? refreshHistory,
    required TResult orElse(),
  }) {
    if (loadHistoryRequests != null) {
      return loadHistoryRequests();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistoryRequests value) loadHistoryRequests,
    required TResult Function(LoadRequestDetails value) loadRequestDetails,
    required TResult Function(RefreshHistory value) refreshHistory,
  }) {
    return loadHistoryRequests(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult? Function(LoadRequestDetails value)? loadRequestDetails,
    TResult? Function(RefreshHistory value)? refreshHistory,
  }) {
    return loadHistoryRequests?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult Function(LoadRequestDetails value)? loadRequestDetails,
    TResult Function(RefreshHistory value)? refreshHistory,
    required TResult orElse(),
  }) {
    if (loadHistoryRequests != null) {
      return loadHistoryRequests(this);
    }
    return orElse();
  }
}

abstract class LoadHistoryRequests implements VocabularyHistoryEvent {
  const factory LoadHistoryRequests() = _$LoadHistoryRequestsImpl;
}

/// @nodoc
abstract class _$$LoadRequestDetailsImplCopyWith<$Res> {
  factory _$$LoadRequestDetailsImplCopyWith(_$LoadRequestDetailsImpl value,
          $Res Function(_$LoadRequestDetailsImpl) then) =
      __$$LoadRequestDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String requestId});
}

/// @nodoc
class __$$LoadRequestDetailsImplCopyWithImpl<$Res>
    extends _$VocabularyHistoryEventCopyWithImpl<$Res, _$LoadRequestDetailsImpl>
    implements _$$LoadRequestDetailsImplCopyWith<$Res> {
  __$$LoadRequestDetailsImplCopyWithImpl(_$LoadRequestDetailsImpl _value,
      $Res Function(_$LoadRequestDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
  }) {
    return _then(_$LoadRequestDetailsImpl(
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadRequestDetailsImpl implements LoadRequestDetails {
  const _$LoadRequestDetailsImpl({required this.requestId});

  @override
  final String requestId;

  @override
  String toString() {
    return 'VocabularyHistoryEvent.loadRequestDetails(requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadRequestDetailsImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId);

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadRequestDetailsImplCopyWith<_$LoadRequestDetailsImpl> get copyWith =>
      __$$LoadRequestDetailsImplCopyWithImpl<_$LoadRequestDetailsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistoryRequests,
    required TResult Function(String requestId) loadRequestDetails,
    required TResult Function() refreshHistory,
  }) {
    return loadRequestDetails(requestId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistoryRequests,
    TResult? Function(String requestId)? loadRequestDetails,
    TResult? Function()? refreshHistory,
  }) {
    return loadRequestDetails?.call(requestId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistoryRequests,
    TResult Function(String requestId)? loadRequestDetails,
    TResult Function()? refreshHistory,
    required TResult orElse(),
  }) {
    if (loadRequestDetails != null) {
      return loadRequestDetails(requestId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistoryRequests value) loadHistoryRequests,
    required TResult Function(LoadRequestDetails value) loadRequestDetails,
    required TResult Function(RefreshHistory value) refreshHistory,
  }) {
    return loadRequestDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult? Function(LoadRequestDetails value)? loadRequestDetails,
    TResult? Function(RefreshHistory value)? refreshHistory,
  }) {
    return loadRequestDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult Function(LoadRequestDetails value)? loadRequestDetails,
    TResult Function(RefreshHistory value)? refreshHistory,
    required TResult orElse(),
  }) {
    if (loadRequestDetails != null) {
      return loadRequestDetails(this);
    }
    return orElse();
  }
}

abstract class LoadRequestDetails implements VocabularyHistoryEvent {
  const factory LoadRequestDetails({required final String requestId}) =
      _$LoadRequestDetailsImpl;

  String get requestId;

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadRequestDetailsImplCopyWith<_$LoadRequestDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshHistoryImplCopyWith<$Res> {
  factory _$$RefreshHistoryImplCopyWith(_$RefreshHistoryImpl value,
          $Res Function(_$RefreshHistoryImpl) then) =
      __$$RefreshHistoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshHistoryImplCopyWithImpl<$Res>
    extends _$VocabularyHistoryEventCopyWithImpl<$Res, _$RefreshHistoryImpl>
    implements _$$RefreshHistoryImplCopyWith<$Res> {
  __$$RefreshHistoryImplCopyWithImpl(
      _$RefreshHistoryImpl _value, $Res Function(_$RefreshHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of VocabularyHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshHistoryImpl implements RefreshHistory {
  const _$RefreshHistoryImpl();

  @override
  String toString() {
    return 'VocabularyHistoryEvent.refreshHistory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshHistoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadHistoryRequests,
    required TResult Function(String requestId) loadRequestDetails,
    required TResult Function() refreshHistory,
  }) {
    return refreshHistory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadHistoryRequests,
    TResult? Function(String requestId)? loadRequestDetails,
    TResult? Function()? refreshHistory,
  }) {
    return refreshHistory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadHistoryRequests,
    TResult Function(String requestId)? loadRequestDetails,
    TResult Function()? refreshHistory,
    required TResult orElse(),
  }) {
    if (refreshHistory != null) {
      return refreshHistory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadHistoryRequests value) loadHistoryRequests,
    required TResult Function(LoadRequestDetails value) loadRequestDetails,
    required TResult Function(RefreshHistory value) refreshHistory,
  }) {
    return refreshHistory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult? Function(LoadRequestDetails value)? loadRequestDetails,
    TResult? Function(RefreshHistory value)? refreshHistory,
  }) {
    return refreshHistory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadHistoryRequests value)? loadHistoryRequests,
    TResult Function(LoadRequestDetails value)? loadRequestDetails,
    TResult Function(RefreshHistory value)? refreshHistory,
    required TResult orElse(),
  }) {
    if (refreshHistory != null) {
      return refreshHistory(this);
    }
    return orElse();
  }
}

abstract class RefreshHistory implements VocabularyHistoryEvent {
  const factory RefreshHistory() = _$RefreshHistoryImpl;
}
