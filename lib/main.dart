// main.dart
// This is the main entry point of the app.
// The app will be organized using feature-first Clean Architecture.
// Features will be added in the lib/features directory.
// Shared code will be placed in lib/core.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/router/page_router.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async work
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase before using any Firebase service or dependency injection
  await Firebase.initializeApp();

  // Register all dependencies after Firebase is ready
  await initDependencies();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning English',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fa')],
      locale: const Locale('en'), // or use a cubit for dynamic switching
      theme:
          AppTheme
              .lightTheme, // Use your custom theme class here if you have one
      initialRoute: PageName.authentication,
      routes: PageRouter.routes,
    );
  }
}
