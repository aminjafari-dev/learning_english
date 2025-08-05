// authentication_page.dart
// Authentication page for Google Sign-In.
//
// Usage Example:
//   Navigator.push(context, MaterialPageRoute(builder: (_) => AuthenticationPage()));
//
// This page uses GScaffold, GButton, GText, and localization.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:learning_english/features/authentication/presentation/widgets/google_sign_in_button.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/constants/image_path.dart';
import 'package:learning_english/features/authentication/presentation/widgets/language_toggle_button.dart';

class AuthenticationPage extends StatelessWidget {
  /// AuthenticationPage displays a card with the app logo, title, Google login button, and terms text.
  ///
  /// Usage Example:
  ///   Navigator.push(context, MaterialPageRoute(builder: (_) => AuthenticationPage()));
  ///
  /// This page uses GScaffold, GButton, GText, GGap, ImagePath, and localization.
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: getIt<AuthenticationBloc>(),
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            // Navigate to Level Selection page on success
            Navigator.pushReplacementNamed(
              context,
              PageName.levelSelection,
              arguments: {'userId': user.id},
            );
          },
          error: (msg) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: GText(msg)));
          },
        );
      },
      builder: (context, state) {
        // Main authentication card UI
        return GScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GGap.g24,
                GGap.g24,
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        ImagePath.learnEnglishBook,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: LanguageToggleButton(),
                    ),
                  ],
                ),
                GGap.g24,
                // Title
                GText(
                  AppLocalizations.of(context)!.learnEnglishTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                GGap.g24,
                // Google login button or loading
                if (state is Loading)
                  const CircularProgressIndicator()
                else
                  GoogleSignInButton(
                    onPressed:
                        () => getIt<AuthenticationBloc>().add(
                          const AuthenticationEvent.googleSignIn(),
                        ),
                  ),
                GGap.g24,
                // Terms & Conditions text
                Spacer(),
                GText(
                  AppLocalizations.of(context)!.termsAndConditions,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                GGap.g24,
              ],
            ),
          ),
        );
      },
    );
  }
}
