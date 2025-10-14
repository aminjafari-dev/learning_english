// main.dart
// This is the main entry point of the app.
// The app will be organized using feature-first Clean Architecture.
// Features will be added in the lib/features directory.
// Shared code will be placed in lib/core.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_themes.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';

import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/router/page_router.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_state.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter bindings are initialized before any async work
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Register all dependencies
  await initDependencies();

  // Initialize localization BLoC
  final localizationBloc = getIt<LocalizationBloc>();
  localizationBloc.add(const LocalizationEvent.loadCurrentLocale());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      bloc: getIt<LocalizationBloc>(),
      builder: (context, localizationState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          bloc: getIt<ThemeCubit>(),
          builder: (context, themeState) {
            // Check both loadCurrentLocale and setLocale states
            Locale currentLocale = const Locale('en');

            if (localizationState.loadCurrentLocale
                is LoadCurrentLocaleCompleted) {
              currentLocale =
                  (localizationState.loadCurrentLocale
                          as LoadCurrentLocaleCompleted)
                      .locale
                      .toLocale();
            } else if (localizationState.setLocale is SetLocaleCompleted) {
              currentLocale =
                  (localizationState.setLocale as SetLocaleCompleted).locale
                      .toLocale();
            }

            return MaterialApp(
              title: 'Lingo',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('fa')],
              locale: currentLocale,
              theme: AppThemes.createThemeData(themeState.themeType),
              initialRoute: PageName.splash,
              routes: PageRouter.routes,
            );
          },
        );
      },
    );
  }
}
