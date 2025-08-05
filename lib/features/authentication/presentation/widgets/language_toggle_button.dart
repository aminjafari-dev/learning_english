// language_toggle_button.dart
// Widget for toggling language on the authentication page.
//
// Usage Example:
//   LanguageToggleButton()
//
// This widget uses the existing LocalizationBloc to change languages.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_bloc.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_event.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_state.dart';

class LanguageToggleButton extends StatelessWidget {
  final LocalizationBloc? localizationBloc;
  
  const LanguageToggleButton({
    super.key,
    this.localizationBloc,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = localizationBloc ?? getIt<LocalizationBloc>();
    
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      bloc: bloc,
      builder: (context, state) {
        // Determine current locale
        LocaleEntity currentLocale = LocaleEntity.english;
        
        if (state.loadCurrentLocale is LoadCurrentLocaleCompleted) {
          currentLocale = (state.loadCurrentLocale as LoadCurrentLocaleCompleted).locale;
        } else if (state.setLocale is SetLocaleCompleted) {
          currentLocale = (state.setLocale as SetLocaleCompleted).locale;
        }

        // Get the next locale to switch to
        final nextLocale = currentLocale.languageCode == 'en' 
            ? LocaleEntity.persian 
            : LocaleEntity.english;
        
        // Get the display text for the next language
        final nextLanguageText = nextLocale.languageCode == 'en' 
            ? 'EN' 
            : 'فا';

        return  GestureDetector(
            onTap: () {
              bloc.add(
                LocalizationEvent.setLocale(locale: nextLocale),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  GText(
                    nextLanguageText,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          
        );
      },
    );
  }
}