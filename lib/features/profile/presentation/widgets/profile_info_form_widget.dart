/// ProfileInfoFormWidget provides form fields for editing user profile information.
///
/// This widget contains text input fields for personal information such as
/// full name, email, phone number, and date of birth. It follows the app's
/// design patterns and uses the established color scheme for visual harmony.
///
/// Usage Example:
///   ProfileInfoFormWidget(
///     fullNameController: fullNameController,
///     emailController: emailController,
///     phoneController: phoneController,
///     dateOfBirthController: dateOfBirthController,
///   );
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_text.dart';

/// Widget for profile information form fields
class ProfileInfoFormWidget extends StatelessWidget {
  /// Controller for full name field
  final TextEditingController fullNameController;

  /// Controller for email field
  final TextEditingController emailController;

  /// Controller for phone number field
  final TextEditingController phoneController;

  /// Controller for date of birth field
  final TextEditingController dateOfBirthController;

  /// Constructor for ProfileInfoFormWidget
  const ProfileInfoFormWidget({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.dateOfBirthController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Full Name Field
        _buildTextField(
          controller: fullNameController,
          label: l10n.fullName,
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        GGap.g16,

        // Email Field
        _buildTextField(
          controller: emailController,
          label: l10n.email,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        GGap.g16,

        // Phone Number Field
        _buildTextField(
          controller: phoneController,
          label: l10n.phoneNumber,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
            }
            return null;
          },
        ),
        GGap.g16,

        // Date of Birth Field
        _buildTextField(
          controller: dateOfBirthController,
          label: l10n.dateOfBirth,
          icon: Icons.calendar_today,
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              final date = DateTime.tryParse(value);
              if (date == null) {
                return 'Please enter a valid date';
              }
              if (date.isAfter(DateTime.now())) {
                return 'Date of birth cannot be in the future';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds a text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(color: AppTheme.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.accentColor),
        filled: true,
        fillColor: AppTheme.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.oliveColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.oliveColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.errorColor, width: 2),
        ),
        labelStyle: TextStyle(color: AppTheme.accentColor),
        errorStyle: TextStyle(color: AppTheme.errorColor),
      ),
    );
  }

  /// Shows date picker for date of birth selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: AppTheme.backgroundColor,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.white,
            ),
            dialogBackgroundColor: AppTheme.surfaceColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateOfBirthController.text = picked.toIso8601String().split('T')[0];
    }
  }
}
