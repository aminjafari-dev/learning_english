// tts_service.dart
// Text-to-Speech service for audio playback of vocabulary and phrases.
// Provides a centralized service for TTS functionality across the app.

import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for audio playback
///
/// This service provides a centralized way to handle TTS functionality
/// across the application. It manages TTS initialization, language settings,
/// and audio playback for vocabulary and phrases.
///
/// Usage Example:
/// ```dart
/// final ttsService = getIt<TTSService>();
/// await ttsService.speak('Hello world');
/// ```
class TTSService {
  static FlutterTts? _flutterTts;
  static bool _isInitialized = false;

  /// Gets the singleton FlutterTts instance
  /// Initializes TTS if not already initialized
  static FlutterTts get _instance {
    _flutterTts ??= FlutterTts();
    return _flutterTts!;
  }

  /// Initializes the TTS service with English language settings
  /// Should be called before using any TTS functionality
  ///
  /// Returns:
  ///   - Future<void>: Completes when TTS is initialized
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _instance.setLanguage("en-US");
      await _instance.setSpeechRate(0.5); // Moderate speed for clarity
      await _instance.setVolume(1.0);
      await _instance.setPitch(1.0);

      _isInitialized = true;
      print('✅ [TTS] Service initialized successfully');
    } catch (e) {
      print('❌ [TTS] Error initializing TTS service: $e');
      rethrow;
    }
  }

  /// Speaks the given text using TTS
  ///
  /// Parameters:
  ///   - text: The text to speak
  ///   - rate: Speech rate (0.1 to 1.0, default: 0.5)
  ///
  /// Returns:
  ///   - Future<void>: Completes when speech starts
  ///
  /// Throws:
  ///   - Exception: If TTS is not initialized or fails to speak
  Future<void> speak(String text, {double rate = 0.5}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      await _instance.setSpeechRate(rate);
      await _instance.speak(text);

      print('🔊 [TTS] Speaking: $text');
    } catch (e) {
      print('❌ [TTS] Error speaking text "$text": $e');
      rethrow;
    }
  }

  /// Speaks vocabulary words and phrases with optimized settings
  /// Uses consistent speech rate for both vocabulary and phrases
  ///
  /// Parameters:
  ///   - text: The vocabulary word or phrase to speak
  ///
  /// Returns:
  ///   - Future<void>: Completes when speech starts
  Future<void> speakText(String text) async {
    await speak(
      text,
      rate: 0.5,
    ); // Consistent rate for both vocabulary and phrases
  }

  /// Stops the current speech
  ///
  /// Returns:
  ///   - Future<void>: Completes when speech stops
  Future<void> stop() async {
    try {
      await _instance.stop();
      print('⏹️ [TTS] Speech stopped');
    } catch (e) {
      print('❌ [TTS] Error stopping speech: $e');
      rethrow;
    }
  }

  /// Gets available voices on the device
  ///
  /// Returns:
  ///   - Future<List<dynamic>>: List of available voices
  Future<List<dynamic>> getAvailableVoices() async {
    try {
      return await _instance.getVoices;
    } catch (e) {
      print('❌ [TTS] Error getting available voices: $e');
      return [];
    }
  }

  /// Sets a specific voice for TTS
  ///
  /// Parameters:
  ///   - voice: The voice identifier to set
  ///
  /// Returns:
  ///   - Future<void>: Completes when voice is set
  Future<void> setVoice(String voice) async {
    try {
      await _instance.setVoice({"name": voice, "locale": "en-US"});
      print('🎤 [TTS] Voice set to: $voice');
    } catch (e) {
      print('❌ [TTS] Error setting voice: $e');
      rethrow;
    }
  }

  /// Disposes the TTS service
  /// Should be called when the app is shutting down
  Future<void> dispose() async {
    try {
      await _instance.stop();
      _flutterTts = null;
      _isInitialized = false;
      print('🗑️ [TTS] Service disposed');
    } catch (e) {
      print('❌ [TTS] Error disposing TTS service: $e');
    }
  }
}

// Example usage:
// final ttsService = getIt<TTSService>();
// await ttsService.speakVocabulary('Hello');
// await ttsService.speakPhrase('How are you doing today?');
