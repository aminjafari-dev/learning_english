// google_sign_in_button.dart
// Widget for Google Sign-In button using GButton.
//
// Usage Example:
//   GoogleSignInButton(onPressed: () { ... });
//
// This widget uses GButton, localization, and ImagePath.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/constants/image_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GButton(
      onPressed: onPressed,
      // If GButton uses 'icon' instead of 'leading', use 'icon' below:
      icon: Image.asset(ImagePath.googleLogo, height: 24),
      text: AppLocalizations.of(context)!.signInWithGoogle,
    );
  }
}
