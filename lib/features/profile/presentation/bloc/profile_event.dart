/// ProfileEvent defines all events that can be dispatched to the ProfileBloc.
///
/// This sealed class uses freezed to generate immutable event classes.
/// Each event represents a specific action that can be performed on the profile,
/// such as loading profile data, updating information, or changing settings.
///
/// Usage Example:
///   context.read<ProfileBloc>().add(ProfileEvent.loadProfile(userId: 'user123'));
///   context.read<ProfileBloc>().add(ProfileEvent.updateProfile(profile: updatedProfile));
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';

part 'profile_event.freezed.dart';

/// Sealed class for profile-related events
@freezed
class ProfileEvent with _$ProfileEvent {
  /// Event to load user profile data
  const factory ProfileEvent.loadProfile({required String userId}) =
      LoadProfile;

  /// Event to update user profile information
  const factory ProfileEvent.updateProfile({required UserProfile profile}) =
      UpdateProfile;

  /// Event to update profile image
  const factory ProfileEvent.updateProfileImage({
    required String userId,
    required String imagePath,
  }) = UpdateProfileImage;

  /// Event to update app language setting
  const factory ProfileEvent.updateAppLanguage({
    required String userId,
    required String language,
  }) = UpdateAppLanguage;

  /// Event to save profile changes
  const factory ProfileEvent.saveChanges({required UserProfile profile}) =
      SaveChanges;

  /// Event to reset profile state
  const factory ProfileEvent.reset() = Reset;
}
