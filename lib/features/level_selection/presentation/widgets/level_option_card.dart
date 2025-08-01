// This widget displays a selectable card for an English level option.
// Usage: Used in the level selection page for each level.
// Example:
//   LevelOptionCard(
//     title: 'Beginner',
//     subtitle: 'For those with little to no English knowledge.',
//     selected: true,
//     onTap: () {},
//   );

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';

class LevelOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const LevelOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // RTL support
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color:
                selected
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.15)
                    : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GText(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GText(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                  border: Border.all(
                    color:
                        selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child:
                    selected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
