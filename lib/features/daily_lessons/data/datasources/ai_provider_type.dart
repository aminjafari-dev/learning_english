// ai_provider_type.dart
// Enum for supported AI providers for lessons generation.

import 'package:hive/hive.dart';

part 'ai_provider_type.g.dart';

/// Supported AI providers for lessons
/// Hive type adapter for AiProviderType - allows storage in Hive boxes
@HiveType(typeId: 2)
enum AiProviderType {
  @HiveField(0)
  openai,
  @HiveField(1)
  gemini,
  @HiveField(2)
  deepseek,
}

// Example usage:
// AiProviderType provider = AiProviderType.openai;
