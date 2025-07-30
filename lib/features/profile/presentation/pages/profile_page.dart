/// ProfilePage displays the user's profile information and allows them to edit it.
///
/// This page provides a comprehensive interface for users to view and update
/// their profile information including personal details, profile image,
/// and app settings. It follows the established design patterns and uses
/// the app's color scheme for visual harmony.
///
/// Usage Example:
///   Navigator.of(context).pushNamed(PageName.profile);
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_event.dart';
import 'package:learning_english/features/profile/presentation/bloc/profile_state.dart';
import 'package:learning_english/features/profile/presentation/widgets/language_selector_widget.dart';
import 'package:learning_english/features/profile/presentation/widgets/profile_image_widget.dart';
import 'package:learning_english/features/profile/presentation/widgets/profile_info_form_widget.dart';

/// The main profile page for managing user profile information
class ProfilePage extends StatefulWidget {
  /// Constructor for ProfilePage
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Form key for profile information form
  final _formKey = GlobalKey<FormState>();

  /// Controllers for form fields
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;

  /// Current user profile data
  UserProfileEntity? _currentProfile;

  /// Flag to track if form has been modified
  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  /// Initializes text controllers with default values
  void _initializeControllers() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
  }

  /// Disposes text controllers to prevent memory leaks
  void _disposeControllers() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
  }

  /// Loads the user profile data
  void _loadProfile() {
    // The BLoC will handle getting the user ID internally through the core use case
    getIt<ProfileBloc>().add(const ProfileEvent.loadProfile());
  }

  /// Updates form controllers with profile data
  void _updateControllers(UserProfileEntity profile) {
    _fullNameController.text = profile.fullName ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phoneNumber ?? '';
    _dateOfBirthController.text =
        profile.dateOfBirth?.toString().split(' ')[0] ?? '';
    _currentProfile = profile;
    _isFormModified = false;
  }

  /// Handles form field changes
  void _onFormChanged() {
    if (_currentProfile != null) {
      setState(() {
        _isFormModified = true;
      });
    }
  }

  /// Saves profile changes
  void _saveChanges() {
    if (_formKey.currentState?.validate() == true && _currentProfile != null) {
      final updatedProfile = _currentProfile!.copyWith(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber:
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
        dateOfBirth:
            _dateOfBirthController.text.isEmpty
                ? null
                : DateTime.tryParse(_dateOfBirthController.text),
      );

      getIt<ProfileBloc>().add(
        ProfileEvent.saveChanges(profile: updatedProfile),
      );
    }
  }

  /// Handles language selection
  void _onLanguageChanged(String language) {
    if (_currentProfile != null) {
      // The BLoC will handle getting the user ID internally through the core use case
      getIt<ProfileBloc>().add(
        ProfileEvent.updateAppLanguage(userId: '', language: language),
      );
    }
  }

  /// Handles profile image update
  void _onProfileImageChanged(String imagePath) {
    if (_currentProfile != null) {
      // The BLoC will handle getting the user ID internally through the core use case
      getIt<ProfileBloc>().add(
        ProfileEvent.updateProfileImage(userId: '', imagePath: imagePath),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GScaffold(
      appBar: AppBar(
        title: GText(l10n.profileTitle),
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: BlocListener<ProfileBloc, ProfileState>(
        bloc: getIt<ProfileBloc>(),
        listener: (context, state) {
          state.whenOrNull(
            loaded: (profile) => _updateControllers(profile),
            updated: (profile) => _updateControllers(profile),
            saved: (profile) {
              _updateControllers(profile);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: GText(l10n.changesSaved),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: GText(l10n.errorSavingChanges),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
          );
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: getIt<ProfileBloc>(),
          builder: (context, state) {
            return state.when(
              initial: () => _buildLoadingWidget(l10n),
              loading: () => _buildLoadingWidget(l10n),
              loaded: (profile) => _buildProfileContent(profile, l10n),
              updating: (profile) => _buildProfileContent(profile, l10n),
              updated: (profile) => _buildProfileContent(profile, l10n),
              error: (message) => _buildErrorWidget(message, l10n),
              saving: (profile) => _buildProfileContent(profile, l10n),
              saved: (profile) => _buildProfileContent(profile, l10n),
            );
          },
        ),
      ),
    );
  }

  /// Builds the loading widget
  Widget _buildLoadingWidget(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          GGap.g16,
          GText(
            l10n.loadingProfile,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Builds the error widget
  Widget _buildErrorWidget(String message, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
          GGap.g16,
          GText(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          GGap.g24,
          GButton(text: l10n.errorRetry, onPressed: _loadProfile),
        ],
      ),
    );
  }

  /// Builds the main profile content
  Widget _buildProfileContent(
    UserProfileEntity profile,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        onChanged: _onFormChanged,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: ProfileImageWidget(
                profileImageUrl: profile.profileImageUrl,
                onImageChanged: _onProfileImageChanged,
              ),
            ),
            GGap.g32,

            // Personal Information Section
            GText(
              l10n.personalInformation,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GGap.g16,

            // Profile Information Form
            ProfileInfoFormWidget(
              fullNameController: _fullNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              dateOfBirthController: _dateOfBirthController,
            ),
            GGap.g32,

            // App Settings Section
            GText(
              l10n.appSettings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GGap.g16,

            // Language Selector
            LanguageSelectorWidget(
              currentLanguage: profile.language ?? 'en',
              onLanguageChanged: _onLanguageChanged,
            ),
            GGap.g32,

            // Save Changes Button
            if (_isFormModified)
              SizedBox(
                width: double.infinity,
                child: GButton(text: l10n.saveChanges, onPressed: _saveChanges),
              ),
          ],
        ),
      ),
    );
  }
}
