// learning_focus_card.dart
// Widget for displaying a learning focus option card.
//
// Usage Example:
//   LearningFocusCard(
//     learningFocus: focus,
//     onTap: () => onFocusSelected(focus.type),
//   );
//
// This widget displays a selectable card for each learning focus option.

import 'package:flutter/material.dart';
import '../../domain/entities/learning_focus.dart';

class LearningFocusCard extends StatelessWidget {
  final LearningFocus learningFocus;
  final VoidCallback onTap;

  const LearningFocusCard({
    super.key,
    required this.learningFocus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = learningFocus.isSelected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              learningFocus.icon,
              size: 32,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              learningFocus.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
