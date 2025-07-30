/// ProfileState defines all states that can be emitted by the ProfileBloc.
///
/// This sealed class uses freezed to generate immutable state classes.
/// Each state represents a specific state of the profile, such as loading,
/// loaded with data, error, or updating.
///
/// Usage Example:
///   BlocBuilder<ProfileBloc, ProfileState>(
///     builder: (context, state) {
///       return state.when(
///         initial: () => InitialWidget(),
///         loading: () => LoadingWidget(),
///         loaded: (profile) => ProfileWidget(profile: profile),
///         error: (message) => ErrorWidget(message: message),
///       );
///     },
///   );
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';

part 'profile_state.freezed.dart';

/// Sealed class for profile-related states
@freezed
class ProfileState with _$ProfileState {
  /// Initial state when no profile data has been loaded
  const factory ProfileState.initial() = ProfileInitial;

  /// Loading state when profile data is being fetched
  const factory ProfileState.loading() = ProfileLoading;

  /// Loaded state when profile data has been successfully retrieved
  const factory ProfileState.loaded({required UserProfileEntity profile}) =
      ProfileLoaded;

  /// Updating state when profile data is being updated
  const factory ProfileState.updating({required UserProfileEntity profile}) =
      ProfileUpdating;

  /// Updated state when profile data has been successfully updated
  const factory ProfileState.updated({required UserProfileEntity profile}) =
      ProfileUpdated;

  /// Error state when an error occurs during profile operations
  const factory ProfileState.error({required String message}) = ProfileError;

  /// Saving state when profile changes are being saved
  const factory ProfileState.saving({required UserProfileEntity profile}) =
      ProfileSaving;

  /// Saved state when profile changes have been successfully saved
  const factory ProfileState.saved({required UserProfileEntity profile}) =
      ProfileSaved;
}
