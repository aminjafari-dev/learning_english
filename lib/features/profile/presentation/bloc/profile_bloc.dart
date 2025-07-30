/// ProfileBloc manages the state and business logic for profile operations.
///
/// This BLoC handles all profile-related events and coordinates with use cases
/// to perform profile operations. It follows the BLoC pattern for state management
/// and maintains a clean separation between UI and business logic.
///
/// Usage Example:
///   BlocProvider(
///     create: (context) => ProfileBloc(
///       getUserProfileUseCase: getUserProfileUseCase,
///       updateUserProfileUseCase: updateUserProfileUseCase,
///       updateProfileImageUseCase: updateProfileImageUseCase,
///       updateAppLanguageUseCase: updateAppLanguageUseCase,
///     ),
///     child: ProfilePage(),
///   );
import 'package:bloc/bloc.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';
import 'package:learning_english/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_app_language_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:learning_english/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_event.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_state.dart';

/// BLoC for managing profile state and operations
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  /// Use case for getting user profile
  final GetUserProfileUseCase _getUserProfileUseCase;

  /// Use case for updating user profile
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  /// Use case for updating profile image
  final UpdateProfileImageUseCase _updateProfileImageUseCase;

  /// Use case for updating app language
  final UpdateAppLanguageUseCase _updateAppLanguageUseCase;

  /// Constructor for ProfileBloc
  ///
  /// Parameters:
  ///   - getUserProfileUseCase: Use case for retrieving user profile
  ///   - updateUserProfileUseCase: Use case for updating user profile
  ///   - updateProfileImageUseCase: Use case for updating profile image
  ///   - updateAppLanguageUseCase: Use case for updating app language
  ProfileBloc({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    required UpdateAppLanguageUseCase updateAppLanguageUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _updateProfileImageUseCase = updateProfileImageUseCase,
       _updateAppLanguageUseCase = updateAppLanguageUseCase,
       super(const ProfileState.initial()) {
    // Register event handlers
    on<ProfileEvent>(_onProfileEvent);
  }

  /// Handles all profile events
  ///
  /// This method routes different events to their appropriate handlers
  /// based on the event type.
  ///
  /// Parameters:
  ///   - event: The profile event to handle
  ///   - emit: Function to emit new states
  Future<void> _onProfileEvent(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await event.when(
      loadProfile: (userId) async => await _onLoadProfile(userId, emit),
      updateProfile: (profile) async => await _onUpdateProfile(profile, emit),
      updateProfileImage:
          (userId, imagePath) async =>
              await _onUpdateProfileImage(userId, imagePath, emit),
      updateAppLanguage:
          (userId, language) async =>
              await _onUpdateAppLanguage(userId, language, emit),
      saveChanges: (profile) async => await _onSaveChanges(profile, emit),
      reset: () async => _onReset(emit),
    );
  }

  /// Handles loading profile data
  ///
  /// This method calls the use case to retrieve user profile data
  /// and emits appropriate states based on the result.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - emit: Function to emit new states
  Future<void> _onLoadProfile(String userId, Emitter<ProfileState> emit) async {
    if (!emit.isDone) {
      emit(const ProfileState.loading());
    }

    final result = await _getUserProfileUseCase.call(
      GetUserProfileParams(userId: userId),
    );

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(ProfileState.error(message: failure.message));
        }
      },
      (profile) {
        if (!emit.isDone) {
          emit(ProfileState.loaded(profile: profile));
        }
      },
    );
  }

  /// Handles updating profile information
  ///
  /// This method calls the use case to update user profile data
  /// and emits appropriate states based on the result.
  ///
  /// Parameters:
  ///   - profile: The updated profile data
  ///   - emit: Function to emit new states
  Future<void> _onUpdateProfile(
    UserProfile profile,
    Emitter<ProfileState> emit,
  ) async {
    if (!emit.isDone) {
      emit(ProfileState.updating(profile: profile));
    }

    final result = await _updateUserProfileUseCase.call(
      UpdateUserProfileParams(userProfile: profile),
    );

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(ProfileState.error(message: failure.message));
        }
      },
      (updatedProfile) {
        if (!emit.isDone) {
          emit(ProfileState.updated(profile: updatedProfile));
        }
      },
    );
  }

  /// Handles updating profile image
  ///
  /// This method calls the use case to upload and update profile image
  /// and emits appropriate states based on the result.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: Local path to the image file
  ///   - emit: Function to emit new states
  Future<void> _onUpdateProfileImage(
    String userId,
    String imagePath,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _updateProfileImageUseCase.call(
      UpdateProfileImageParams(userId: userId, imagePath: imagePath),
    );

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(ProfileState.error(message: failure.message));
        }
      },
      (imageUrl) {
        // Update the current profile with the new image URL
        if (state is ProfileLoaded && !emit.isDone) {
          final currentProfile = (state as ProfileLoaded).profile;
          final updatedProfile = currentProfile.copyWith(
            profileImageUrl: imageUrl,
          );
          emit(ProfileState.updated(profile: updatedProfile));
        }
      },
    );
  }

  /// Handles updating app language
  ///
  /// This method calls the use case to update the app language setting
  /// and emits appropriate states based on the result.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - language: The language code to set
  ///   - emit: Function to emit new states
  Future<void> _onUpdateAppLanguage(
    String userId,
    String language,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _updateAppLanguageUseCase.call(
      UpdateAppLanguageParams(userId: userId, language: language),
    );

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(ProfileState.error(message: failure.message));
        }
      },
      (updatedLanguage) {
        // Update the current profile with the new language
        if (state is ProfileLoaded && !emit.isDone) {
          final currentProfile = (state as ProfileLoaded).profile;
          final updatedProfile = currentProfile.copyWith(
            language: updatedLanguage,
          );
          emit(ProfileState.updated(profile: updatedProfile));
        }
      },
    );
  }

  /// Handles saving profile changes
  ///
  /// This method calls the use case to save profile changes
  /// and emits appropriate states based on the result.
  ///
  /// Parameters:
  ///   - profile: The profile data to save
  ///   - emit: Function to emit new states
  Future<void> _onSaveChanges(
    UserProfile profile,
    Emitter<ProfileState> emit,
  ) async {
    if (!emit.isDone) {
      emit(ProfileState.saving(profile: profile));
    }

    final result = await _updateUserProfileUseCase.call(
      UpdateUserProfileParams(userProfile: profile),
    );

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(ProfileState.error(message: failure.message));
        }
      },
      (savedProfile) {
        if (!emit.isDone) {
          emit(ProfileState.saved(profile: savedProfile));
        }
      },
    );
  }

  /// Handles resetting the profile state
  ///
  /// This method resets the BLoC to its initial state.
  ///
  /// Parameters:
  ///   - emit: Function to emit new states
  void _onReset(Emitter<ProfileState> emit) {
    if (!emit.isDone) {
      emit(const ProfileState.initial());
    }
  }
}
