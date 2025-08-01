// phrase_card.dart
// Widget for displaying a phrase (English and Persian translation).
// Now includes shimmer loading animation for better UX during loading states.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/phrase.dart';

/// Widget for displaying a phrase with English and Persian translations
/// Supports shimmer loading animation for better user experience
/// Now includes audio icon for phrase pronunciation
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface,
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
      baseColor: AppTheme.surface,
      highlightColor: AppTheme.hint.withOpacity(0.3),
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
  /// Now includes audio icon for phrase pronunciation
  Widget _buildPhraseContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Audio icon button for phrase
            _buildAudioIconButton(context, phrase!.english),
            GGap.g8,
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: GText(
                    phrase!.english,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        GGap.g4,
        Align(
          alignment: Alignment.centerRight,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GText(
              phrase!.persian,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.hint),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds audio icon button for phrase pronunciation
  /// Uses volume_up icon with gold color and suitable size
  /// Handles tap events for audio playback
  Widget _buildAudioIconButton(BuildContext context, String english) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement audio playback functionality
        // This will be connected to the bloc for audio playback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing audio for: $english'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.volume_up, size: 16, color: AppTheme.primaryColor),
      ),
    );
  }
}

// Example usage:
// PhraseCard(phrase: Phrase(english: 'I owe it to myself', persian: 'به اون امیدوارم'))
// PhraseCard(isLoading: true) // For loading state with shimmer
