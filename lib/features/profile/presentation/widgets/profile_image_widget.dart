/// ProfileImageWidget displays and allows editing of the user's profile image.
///
/// This widget provides a circular profile image display with an edit button
/// that allows users to change their profile picture. It follows the app's
/// design patterns and color scheme for visual harmony.
///
/// Usage Example:
///   ProfileImageWidget(
///     profileImageUrl: 'https://example.com/image.jpg',
///     onImageChanged: (imagePath) => print('Image changed: $imagePath'),
///   );
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_text.dart';

/// Widget for displaying and editing profile image
class ProfileImageWidget extends StatelessWidget {
  /// URL of the current profile image
  final String? profileImageUrl;

  /// Callback function when image is changed
  final Function(String imagePath) onImageChanged;

  /// Constructor for ProfileImageWidget
  const ProfileImageWidget({
    super.key,
    this.profileImageUrl,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Profile Image Display
        Stack(
          children: [
            // Profile Image Circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceColor,
                border: Border.all(color: AppTheme.primaryColor, width: 3),
              ),
              child: ClipOval(
                child:
                    profileImageUrl != null
                        ? Image.network(
                          profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        )
                        : _buildDefaultAvatar(),
              ),
            ),

            // Edit Button
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                  border: Border.all(color: AppTheme.backgroundColor, width: 3),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: AppTheme.backgroundColor,
                  ),
                  onPressed: () => _showImagePickerDialog(context, l10n),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        GGap.g16,

        // Change Photo Text
        GText(
          l10n.changePhoto,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryColor),
        ),
      ],
    );
  }

  /// Builds the default avatar when no image is available
  Widget _buildDefaultAvatar() {
    return Container(
      color: AppTheme.secondaryBackground,
      child: Icon(Icons.person, size: 60, color: AppTheme.accentColor),
    );
  }

  /// Shows the image picker dialog
  void _showImagePickerDialog(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                GGap.g24,

                // Title
                GText(
                  l10n.profileImage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                GGap.g24,

                // Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                                    _buildImageOption(
                  context,
                  l10n.takePhoto,
                  Icons.camera_alt,
                  () => _pickImage(context, 'camera'),
                ),
                _buildImageOption(
                  context,
                  l10n.chooseFromGallery,
                  Icons.photo_library,
                  () => _pickImage(context, 'gallery'),
                ),
                  ],
                ),
                GGap.g16,

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: GText(
                      l10n.cancel,
                      style: TextStyle(color: AppTheme.accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// Builds an image option button
  Widget _buildImageOption(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: AppTheme.backgroundColor),
          label: GText(text, style: TextStyle(color: AppTheme.backgroundColor)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  /// Picks an image from the specified source
  Future<void> _pickImage(BuildContext context, String source) async {
    try {
      // TODO: Implement image picker when dependency is properly configured
      // For now, simulate image selection
      onImageChanged('/placeholder/image/path');
      Navigator.of(context).pop();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: GText('Image picker not yet implemented'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      // Handle error silently or show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: GText('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
