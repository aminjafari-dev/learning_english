// audio_button.dart
// Reusable audio button widget for vocabulary and phrase pronunciation.
// Provides consistent styling and functionality across the app.

import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/dependency injection/locator.dart';
import 'package:learning_english/core/services/tts_service.dart';

/// Reusable audio button widget for text-to-speech functionality
///
/// This widget provides a consistent audio button that can be used
/// for both vocabulary words and phrases. It handles TTS initialization,
/// error handling, and provides visual feedback.
///
/// Usage Example:
/// ```dart
/// AudioButton(
///   text: 'Hello',
///   onSuccess: () => print('Audio played successfully'),
///   onError: (error) => print('Error: $error'),
/// )
/// ```
class AudioButton extends StatefulWidget {
  /// The text to be spoken when the button is tapped
  final String text;

  /// Optional callback when audio plays successfully
  final VoidCallback? onSuccess;

  /// Optional callback when audio playback fails
  final Function(String error)? onError;

  /// Size of the audio icon (default: 16)
  final double iconSize;

  /// Padding around the icon (default: 4)
  final double padding;

  /// Creates an audio button widget
  ///
  /// [text] - The text to speak when button is tapped
  /// [onSuccess] - Optional callback for successful audio playback
  /// [onError] - Optional callback for audio playback errors
  /// [iconSize] - Size of the audio icon
  /// [padding] - Padding around the icon
  const AudioButton({
    super.key,
    required this.text,
    this.onSuccess,
    this.onError,
    this.iconSize = 16,
    this.padding = 4,
  });

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  bool _isPlaying = false;

  /// Handles the tap event for audio playback
  /// Initializes TTS if needed and plays the text
  Future<void> _handleTap() async {
    if (_isPlaying) return; // Prevent multiple simultaneous plays

    setState(() {
      _isPlaying = true;
    });

    try {
      // Get TTS service from dependency injection
      final ttsService = getIt<TTSService>();

      // Play audio for the text
      await ttsService.speakText(widget.text);

      // Call success callback if provided
      widget.onSuccess?.call();

      print('🔊 [AudioButton] Successfully played: ${widget.text}');
    } catch (e) {
      // Call error callback if provided
      widget.onError?.call(e.toString());

      print('❌ [AudioButton] Error playing audio: $e');
    } finally {
      // Reset playing state
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: AppTheme.gold.withValues(alpha: 0.5),
        highlightColor: AppTheme.gold.withValues(alpha: 0.5),
        onTap: _isPlaying ? null : _handleTap,
        child: Container(
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            color:
                _isPlaying
                    ? AppTheme.gold.withValues(alpha: .3) // Darker when playing
                    : AppTheme.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _isPlaying ? Icons.volume_up : Icons.volume_up,
            size: widget.iconSize,
            color:
                _isPlaying
                    ? AppTheme.gold.withOpacity(
                      0.8,
                    ) // Slightly dimmed when playing
                    : AppTheme.gold,
          ),
        ),
      ),
    );
  }
}

// Example usage:
// AudioButton(
//   text: 'Hello world',
//   onSuccess: () => print('Audio played'),
//   onError: (error) => print('Error: $error'),
// )
