// vocabulary_section.dart
// Widget for displaying the vocabularies section.
// Now uses shimmer loading animation for better user experience during loading states.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';

/// Widget for displaying the vocabularies section
/// Handles different states: initial, loading, loaded, and error
/// Now uses shimmer loading animation for better user experience
class VocabularySection extends StatelessWidget {
  final VocabulariesState state;
  const VocabularySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => const SizedBox(),
      loading: () => _buildShimmerLoading(context),
      loaded: (vocabularies) => _buildVocabulariesList(context, vocabularies),
      error: (msg) => _buildErrorWidget(msg),
    );
  }

  /// Builds shimmer loading animation for vocabularies
  /// Creates multiple shimmer vocabulary rows to mimic the actual content
  /// Provides better user experience compared to circular progress indicator
  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surface,
      highlightColor: AppTheme.hint.withOpacity(0.3),
      child: Column(
        children: List.generate(
          5, // Show 5 shimmer vocabulary rows during loading
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
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
                // English word shimmer
                Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                // Persian translation shimmer
                Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the vocabularies list when data is loaded
  /// Displays English words with their Persian translations in a row layout
  /// Now includes audio icons for each vocabulary word
  Widget _buildVocabulariesList(
    BuildContext context,
    List<dynamic> vocabularies,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          vocabularies
              .map(
                (vocab) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      // Audio icon button for vocabulary
                      _buildAudioIconButton(context, vocab.english),
                      GGap.g8,
                      GText(
                        vocab.english,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GGap.g8,
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: GText(
                              vocab.persian,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.hint),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  /// Builds audio icon button for vocabulary pronunciation
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

  /// Builds error widget when vocabularies fail to load
  Widget _buildErrorWidget(String message) {
    return GText(message, style: const TextStyle(color: Colors.red));
  }
}

// Example usage:
// VocabularySection(state: state.vocabularies)
