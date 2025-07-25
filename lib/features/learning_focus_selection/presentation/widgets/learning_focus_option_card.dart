import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
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
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.accentColor,
                semanticLabel: title,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GText(title, style: Theme.of(context).textTheme.bodyLarge),
                  GText(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
