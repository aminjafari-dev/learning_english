// test_auth_integration.dart
// Test file to verify Supabase authentication integration
// This file can be used to test the authentication flow

import 'package:flutter/material.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/features/authentication/domain/repositories/auth_repository.dart';
import 'package:learning_english/features/authentication/domain/entities/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Test function to verify Supabase authentication integration
/// This function can be called from your app to test the authentication flow
Future<void> testSupabaseAuthIntegration() async {
  try {
    print('🧪 Testing Supabase Authentication Integration...');

    // Get the authentication repository
    final authRepository = getIt<AuthRepository>();

    // Test 1: Check if user is currently signed in
    print('📋 Test 1: Checking current user...');
    final currentUser = await authRepository.getCurrentUser();
    if (currentUser != null) {
      print('✅ User is signed in: ${currentUser.name} (${currentUser.email})');
    } else {
      print('ℹ️  No user currently signed in');
    }

    // Test 2: Test Google Sign-In (this will open the Google Sign-In flow)
    print('📋 Test 2: Testing Google Sign-In...');
    print(
      '⚠️  This will open Google Sign-In dialog. Cancel if you want to skip this test.',
    );

    // Uncomment the following lines to test Google Sign-In
    // final signInResult = await authRepository.signInWithGoogle();
    // signInResult.fold(
    //   (failure) => print('❌ Sign-In failed: ${failure.message}'),
    //   (user) => print('✅ Sign-In successful: ${user.name} (${user.email})'),
    // );

    // Test 3: Test sign out
    print('📋 Test 3: Testing sign out...');
    try {
      await authRepository.signOut();
      print('✅ Sign out successful');
    } catch (e) {
      print('❌ Sign out failed: $e');
    }

    print('🎉 Authentication integration test completed!');
  } catch (e) {
    print('❌ Error during authentication test: $e');
  }
}

/// Test function specifically for Google Sign-In initialization
Future<void> testGoogleSignInInitialization() async {
  try {
    print('🧪 Testing Google Sign-In Initialization...');

    // Test Google Sign-In initialization
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      clientId:
          '25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com',
    );

    print('✅ Google Sign-In initialization successful');
    print('ℹ️  Google Sign-In is ready for authentication');
  } catch (e) {
    print('❌ Google Sign-In initialization failed: $e');
  }
}

/// Widget to test authentication in the UI
class AuthTestWidget extends StatelessWidget {
  const AuthTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Integration Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => testSupabaseAuthIntegration(),
              child: const Text('Test Authentication Integration'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => testGoogleSignInInitialization(),
              child: const Text('Test Google Sign-In Initialization'),
            ),
            const SizedBox(height: 20),
            const Text(
              'This will test the Supabase + Google Sign-In integration',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
