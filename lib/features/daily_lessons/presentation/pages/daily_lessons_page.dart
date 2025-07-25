// daily_lessons_page.dart
// Main page for the Daily Lessons feature.
// This page displays vocabularies, phrases, and lesson sections, using Bloc for state management.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/daily_lessons_header.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/daily_lessons_content.dart';

/// The main Daily Lessons page widget.
class DailyLessonsPage extends StatelessWidget {
  const DailyLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use getIt for dependency injection instead of BlocProvider in the UI
    final bloc =
        getIt<DailyLessonsBloc>()
          ..add(const DailyLessonsEvent.fetchLessons());

    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const DailyLessonsHeader(),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
          bloc: bloc,
          builder: (context, state) {
            return DailyLessonsContent(state: state);
          },
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.of(context).pushNamed(PageName.dailyLessons);
