// refresh_button.dart
// Refresh button widget for the Daily Lessons page.
// Shows loading indicator or button based on refresh state.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';

/// Refresh button widget for the Daily Lessons page
/// Shows loading indicator or button based on refresh state
class RefreshButton extends StatelessWidget {
  final bool isRefreshing;

  const RefreshButton({super.key, required this.isRefreshing});

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return const Center(child: SizedBox.shrink());
    }

    return GButton(
      text: AppLocalizations.of(context)!.nextLessons,
      onPressed: () {
        final bloc = getIt<DailyLessonsBloc>();
        bloc.add(const DailyLessonsEvent.refreshLessons());
      },
      color: AppTheme.primary(context),
    );
  }
}

// Example usage:
// RefreshButton(isRefreshing: state.isRefreshing)
