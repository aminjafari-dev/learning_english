/// LanguageSelectorWidget provides a language selection interface.
///
/// This widget displays language options in a card format and allows users
/// to select their preferred app language. It follows the app's design
/// patterns and uses the established color scheme for visual harmony.
///
/// Usage Example:
///   LanguageSelectorWidget(
///     currentLanguage: 'en',
///     onLanguageChanged: (language) => print('Language changed: $language'),
///   );
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_text.dart';

/// Widget for selecting app language
class LanguageSelectorWidget extends StatelessWidget {
  /// Current selected language code
  final String currentLanguage;

  /// Callback function when language is changed
  final Function(String language) onLanguageChanged;

  /// Constructor for LanguageSelectorWidget
  const LanguageSelectorWidget({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.oliveColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language Label
          Row(
            children: [
              Icon(Icons.language, color: AppTheme.accentColor, size: 20),
              GGap.g8,
              GText(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          GGap.g16,

          // Language Options
          Row(
            children: [
              Expanded(
                child: _buildLanguageOption(
                  context,
                  'en',
                  l10n.english,
                  currentLanguage == 'en',
                ),
              ),
              GGap.g12,
              Expanded(
                child: _buildLanguageOption(
                  context,
                  'fa',
                  l10n.persian,
                  currentLanguage == 'fa',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a language option button
  Widget _buildLanguageOption(
    BuildContext context,
    String languageCode,
    String languageName,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => onLanguageChanged(languageCode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected ? AppTheme.primaryColor : AppTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.oliveColor,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.backgroundColor,
                size: 16,
              ),
            if (isSelected) GGap.g8,
            GText(
              languageName,
              style: TextStyle(
                color: isSelected ? AppTheme.backgroundColor : AppTheme.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
