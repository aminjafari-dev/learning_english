// section_header.dart
// Reusable section header for Daily Lessons sections.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GText(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme.primary(context),
      ),
    );
  }
}

// Example usage:
// SectionHeader(title: 'Vocabularies')
