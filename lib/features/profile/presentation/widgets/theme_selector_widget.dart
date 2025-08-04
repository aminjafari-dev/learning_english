import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';

/// Widget for selecting app themes
class ThemeSelectorWidget extends StatelessWidget {
  /// Constructor for ThemeSelectorWidget
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCubit = getIt<ThemeCubit>();

    return BlocBuilder<ThemeCubit, ThemeState>(
      bloc: themeCubit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.secondary(context), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Label
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: AppTheme.accent(context),
                    size: 20,
                  ),
                  GGap.g8,
                  GText(
                    l10n.theme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              GGap.g16,

              // Theme Options
              Column(
                children: [
                  _buildThemeOption(
                    context,
                    l10n,
                    ThemeType.gold,
                    l10n.goldTheme,
                    state.themeType == ThemeType.gold,
                    () async => await themeCubit.switchTheme(ThemeType.gold),
                  ),
                  GGap.g12,
                  _buildThemeOption(
                    context,
                    l10n,
                    ThemeType.blue,
                    l10n.blueTheme,
                    state.themeType == ThemeType.blue,
                    () async => await themeCubit.switchTheme(ThemeType.blue),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a theme option widget
  Widget _buildThemeOption(
    BuildContext context,
    AppLocalizations l10n,
    ThemeType themeType,
    String label,
    bool isSelected,
    Future<void> Function() onTap,
  ) {
    return InkWell(
      onTap: () async => await onTap(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primary(context).withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? AppTheme.primary(context)
                    : AppTheme.secondary(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Theme Color Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getThemeColor(context, themeType),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.secondary(context),
                  width: 2,
                ),
              ),
            ),
            GGap.g12,

            // Theme Label
            Expanded(
              child: GText(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primary(context),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Gets the primary color for a theme type
  Color _getThemeColor(BuildContext context, ThemeType themeType) {
    switch (themeType) {
      case ThemeType.gold:
        return const Color(0xFFD1A317); // Gold
      case ThemeType.blue:
        return const Color(0xFF0D80F2); // Blue
    }
  }
}
