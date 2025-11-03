// phrase_card.dart
// Widget for displaying a phrase (English and Persian translation).
// Now includes shimmer loading animation for better UX during loading states.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/audio_button.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/phrase.dart';
import 'package:learning_english/core/services/tts_service.dart';
import 'package:learning_english/core/dependency injection/locator.dart';

/// Widget for displaying a phrase with English and Persian translations
/// Supports shimmer loading animation for better user experience
/// Now uses the reusable AudioButton widget for consistent audio functionality
///
/// Usage:
/// ```dart
/// // Normal phrase display
/// PhraseCard(phrase: phrase)
///
/// // Loading state with shimmer
/// PhraseCard(isLoading: true)
/// ```
class PhraseCard extends StatelessWidget {
  final Phrase? phrase;
  final bool isLoading;

  /// Creates a phrase card widget
  ///
  /// [phrase] - The phrase to display (required when not loading)
  /// [isLoading] - Whether to show shimmer loading animation (default: false)
  const PhraseCard({super.key, this.phrase, this.isLoading = false})
    : assert(
        phrase != null || isLoading,
        'Either phrase or isLoading must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          isLoading
              ? _buildShimmerContent(context)
              : _buildPhraseContent(context),
    );
  }

  /// Builds the shimmer loading animation content
  /// Creates placeholder rectangles that mimic the actual content structure
  Widget _buildShimmerContent(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surface(context),
      highlightColor: AppTheme.hint(context).withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Audio icon shimmer
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              GGap.g8,
              // English text shimmer
              Expanded(
                child: Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          GGap.g4,
          // Persian text shimmer (shorter width to mimic RTL text)
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the actual phrase content when not loading
  /// Displays English and Persian translations with proper styling
  /// Now uses the reusable AudioButton widget for consistent audio functionality
  /// English text is also clickable for audio playback
  Widget _buildPhraseContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: TextDirection.ltr,
          children: [
            // Audio button for phrase using reusable widget
            AudioButton(
              text: phrase!.english,
              onError: (error) {
                // Show error feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: GText('❌ Error playing audio: $error'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            GGap.g8,
            // English text where each word is individually tappable for audio playback
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: _buildInteractiveEnglishText(context),
              ),
            ),
          ],
        ),
        GGap.g4,
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: GText(
                    phrase!.persian,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.hint(context),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a RichText where each English word is individually tappable.
  /// Spaces and punctuation are preserved as non-tappable text.
  Widget _buildInteractiveEnglishText(BuildContext context) {
    final TextStyle effectiveStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          decorationColor: AppTheme.primary(context).withValues(alpha: 0.7),
        ) ??
        const TextStyle(fontWeight: FontWeight.bold);

    final String text = phrase!.english;
    final List<InlineSpan> spans = _buildWordAndSeparatorSpans(
      context: context,
      text: text,
      style: effectiveStyle,
    );

    return RichText(
      text: TextSpan(children: spans, style: effectiveStyle),
      textDirection: TextDirection.ltr,
    );
  }

  /// Tokenizes [text] into words and separators and returns spans where
  /// words are wrapped in tappable widgets to trigger TTS for that word.
  List<InlineSpan> _buildWordAndSeparatorSpans({
    required BuildContext context,
    required String text,
    required TextStyle style,
  }) {
    final List<InlineSpan> spans = <InlineSpan>[];
    final RegExp wordExp = RegExp(r"[A-Za-z]+(?:[-'][A-Za-z]+)*");
    int index = 0;

    for (final RegExpMatch match in wordExp.allMatches(text)) {
      if (match.start > index) {
        final String separator = text.substring(index, match.start);
        spans.add(TextSpan(text: separator, style: style));
      }

      final String word = match.group(0)!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              splashColor: Theme.of(context).primaryColor.withValues(alpha: .2),
              highlightColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: .2),
              onTap: () async {
                try {
                  final ttsService = getIt<TTSService>();
                  await ttsService.speakText(word);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: GText('❌ Error playing audio: $e'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(word, style: style, textDirection: TextDirection.ltr),
            ),
          ),
        ),
      );

      index = match.end;
    }

    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index), style: style));
    }

    return spans;
  }
}

// Example usage:
// PhraseCard(phrase: Phrase(english: 'I owe it to myself', persian: 'به اون امیدوارم'))
// PhraseCard(isLoading: true) // For loading state with shimmer
