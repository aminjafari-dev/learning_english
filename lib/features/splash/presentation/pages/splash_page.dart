// splash_page.dart
// The main splash page that displays a loading screen and handles navigation.
//
// Usage Example:
//   Navigator.of(context).pushReplacementNamed(PageName.splash);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency injection/locator.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/constants/image_path.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:learning_english/features/splash/presentation/bloc/splash_event.dart';
import 'package:learning_english/features/splash/presentation/bloc/splash_state.dart';

/// The main splash page that displays a loading screen and handles navigation
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger authentication check when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<SplashBloc>().add(
        const SplashEvent.checkAuthenticationStatus(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      bloc: getIt<SplashBloc>(),

      listener: (context, state) {
        state.when(
          initial: () {
            // Do nothing, wait for the event to be triggered
          },
          loading: () {
            // Show loading state
          },
          authenticated: (userId) {
            // Navigate to level selection page
            _navigateToLevelSelection();
          },
          unauthenticated: () {
            // Navigate to authentication page
            _navigateToAuthentication();
          },
          error: (message) {
            // Show error and navigate to authentication page
            _showErrorAndNavigateToAuth(message);
          },
        );
      },
      builder: (context, state) {
        return GScaffold(body: _buildSplashContent(state));
      },
    );
  }

  /// Builds the splash content based on the current state
  Widget _buildSplashContent(SplashState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo or image
          Image.asset(
            ImagePath.googleLogo, // You can change this to your app logo
            width: 120,
            height: 120,
          ),
          GGap.g32,

          // App title
          const GText(
            'Learning English',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          GGap.g16,

          // Loading indicator
          const CircularProgressIndicator(),
          GGap.g16,

          // Loading text
          const GText(
            'Loading...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Navigates to the level selection page
  void _navigateToLevelSelection() {
    Navigator.of(context).pushReplacementNamed(PageName.mainNavigation);
  }

  /// Navigates to the authentication page
  void _navigateToAuthentication() {
    Navigator.of(context).pushReplacementNamed(PageName.authentication);
  }

  /// Shows error message and navigates to authentication page
  void _showErrorAndNavigateToAuth(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: GText('Error: $message'), backgroundColor: Colors.red),
    );
    // Navigate to authentication page after showing error
    Future.delayed(const Duration(seconds: 2), () {
      _navigateToAuthentication();
    });
  }
}
