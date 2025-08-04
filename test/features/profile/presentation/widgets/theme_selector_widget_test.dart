import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';
import 'package:learning_english/features/profile/presentation/widgets/theme_selector_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeSelectorWidget', () {
    late ThemeCubit themeCubit;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      themeCubit = ThemeCubit(prefs: prefs);
      getIt.registerSingleton<ThemeCubit>(themeCubit);
    });

    tearDown(() {
      themeCubit.close();
      getIt.reset();
    });

    testWidgets('should display theme options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const Scaffold(body: ThemeSelectorWidget()),
          ),
        ),
      );

      // Verify that theme options are displayed
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Gold Theme'), findsOneWidget);
      expect(find.text('Blue Theme'), findsOneWidget);
    });

    testWidgets('should switch theme when option is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const Scaffold(body: ThemeSelectorWidget()),
          ),
        ),
      );

      // Initially should be gold theme
      expect(themeCubit.currentTheme, equals(ThemeType.gold));

      // Tap on blue theme option
      await tester.tap(find.text('Blue Theme'));
      await tester.pumpAndSettle();

      // Should switch to blue theme
      expect(themeCubit.currentTheme, equals(ThemeType.blue));
    });
  });
}
