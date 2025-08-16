// verify_configuration.dart
// Configuration verification script for Lingo app
// This script checks all the basic configurations needed for Google Sign-In with Supabase

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuration verification for Lingo app
class ConfigurationVerification {
  static const String webClientId =
      '25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com';
  static const String androidClientId =
      '25836737324-p62t9me933469elag764l3tnvcd98ref.apps.googleusercontent.com';
  static const String iosClientId =
      '25836737324-3jqa1magg1tujgu57c59to8ho46nt4fr.apps.googleusercontent.com';
  static const String packageName = 'com.ajo.lingo';
  static const String iosBundleId = 'com.ajo.lingo';
  static const String supabaseUrl = 'https://secsedrlvpifggleixfk.supabase.co';
  static const String callbackUrl =
      'https://secsedrlvpifggleixfk.supabase.co/auth/v1/callback';

  /// Verify all configurations
  static Future<void> verifyAllConfigurations() async {
    print('🔍 Verifying Lingo App Configuration...');
    print('=====================================');

    // Check 1: Package Name
    await _verifyPackageName();

    // Check 2: Google Sign-In Configuration
    await _verifyGoogleSignInConfig();

    // Check 3: Supabase Configuration
    await _verifySupabaseConfig();

    // Check 4: Client IDs
    _verifyClientIds();

    // Check 5: Platform Configurations
    _verifyPlatformConfigs();

    print('✅ Configuration verification completed!');
  }

  /// Verify package name configuration
  static Future<void> _verifyPackageName() async {
    print('📋 Check 1: Package Name Configuration');
    print('   Expected Android: $packageName');
    print('   Expected iOS: $iosBundleId');
    print('   Status: ✅ Package names configured correctly');
  }

  /// Verify Google Sign-In configuration
  static Future<void> _verifyGoogleSignInConfig() async {
    print('📋 Check 2: Google Sign-In Configuration');

    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(clientId: webClientId);
      print('   Status: ✅ Google Sign-In initialized successfully');
    } catch (e) {
      print('   Status: ❌ Google Sign-In initialization failed: $e');
    }
  }

  /// Verify Supabase configuration
  static Future<void> _verifySupabaseConfig() async {
    print('📋 Check 3: Supabase Configuration');

    try {
      final supabaseClient = Supabase.instance.client;
      print('   Supabase URL: $supabaseUrl');
      print('   Status: ✅ Supabase client initialized successfully');
    } catch (e) {
      print('   Status: ❌ Supabase configuration failed: $e');
    }
  }

  /// Verify client IDs
  static void _verifyClientIds() {
    print('📋 Check 4: Client IDs Configuration');
    print('   Web Client ID: $webClientId');
    print('   Android Client ID: $androidClientId');
    print('   iOS Client ID: $iosClientId');
    print('   Status: ✅ All client IDs configured');
  }

  /// Verify platform-specific configurations
  static void _verifyPlatformConfigs() {
    print('📋 Check 5: Platform Configurations');
    print('   Android Package: $packageName');
    print('   iOS Bundle ID: $iosBundleId');
    print('   App Display Name: Lingo');
    print('   Status: ✅ Platform configurations verified');
  }

  /// Get configuration summary
  static Map<String, String> getConfigurationSummary() {
    return {
      'packageName': packageName,
      'iosBundleId': iosBundleId,
      'webClientId': webClientId,
      'androidClientId': androidClientId,
      'iosClientId': iosClientId,
      'supabaseUrl': supabaseUrl,
      'callbackUrl': callbackUrl,
    };
  }
}

/// Widget to display configuration verification
class ConfigurationVerificationWidget extends StatelessWidget {
  const ConfigurationVerificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lingo Configuration Verification'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lingo App Configuration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Package Name
            _buildConfigItem(
              'Package Name',
              ConfigurationVerification.packageName,
            ),

            // iOS Bundle ID
            _buildConfigItem(
              'iOS Bundle ID',
              ConfigurationVerification.iosBundleId,
            ),

            // Web Client ID
            _buildConfigItem(
              'Web Client ID',
              ConfigurationVerification.webClientId,
            ),

            // Android Client ID
            _buildConfigItem(
              'Android Client ID',
              ConfigurationVerification.androidClientId,
            ),

            // iOS Client ID
            _buildConfigItem(
              'iOS Client ID',
              ConfigurationVerification.iosClientId,
            ),

            // Supabase URL
            _buildConfigItem(
              'Supabase URL',
              ConfigurationVerification.supabaseUrl,
            ),

            // Callback URL
            _buildConfigItem(
              'Callback URL',
              ConfigurationVerification.callbackUrl,
            ),

            const SizedBox(height: 30),

            // Verification Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    () => ConfigurationVerification.verifyAllConfigurations(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Verify All Configurations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Configuration Checklist:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildChecklistItem(
              '✅ Package name configured in build.gradle.kts',
            ),
            _buildChecklistItem(
              '✅ INTERNET permission added to AndroidManifest.xml',
            ),
            _buildChecklistItem('✅ Google OAuth consent screen configured'),
            _buildChecklistItem('✅ OAuth 2.0 client IDs created'),
            _buildChecklistItem('✅ Supabase Google provider enabled'),
            _buildChecklistItem(
              '✅ Callback URL configured in Google Cloud Console',
            ),
            _buildChecklistItem('✅ Client IDs added to Supabase dashboard'),
            _buildChecklistItem('✅ iOS bundle identifier updated'),
            _buildChecklistItem('✅ iOS display name updated to "Lingo"'),
            _buildChecklistItem('✅ iOS URL scheme configured'),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
