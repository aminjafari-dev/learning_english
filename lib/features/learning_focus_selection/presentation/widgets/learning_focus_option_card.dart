import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';

/// A reusable card widget for displaying a learning focus option.
///
/// Usage Example:
/// ```dart
/// LearningFocusOptionCard(
///   icon: Icons.work,
///   title: 'Business',
///   subtitle: 'English',
///   selected: true,
///   onTap: () {},
/// )
/// ```
///
/// Parameters:
/// - [icon]: The icon to display (e.g., Icons.work).
/// - [title]: The first line of text (e.g., 'Business').
/// - [subtitle]: The second line of text (e.g., 'English').
/// - [selected]: Whether the card is selected (affects border/background).
/// - [onTap]: Callback when the card is tapped.
class LearningFocusOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const LearningFocusOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppTheme.primaryColor : AppTheme.oliveColor;
    final backgroundColor =
        selected ? AppTheme.surfaceColor : Colors.transparent;
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: AppTheme.accentColor,
                semanticLabel: title,
              ),
              GGap.g8,
              // Make the text column flexible to avoid overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GText(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty)
                      GText(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
