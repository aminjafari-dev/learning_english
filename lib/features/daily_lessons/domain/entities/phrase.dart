// phrase.dart
// Entity representing a phrase item in the domain layer.

class Phrase {
  final String english;
  final String persian;

  /// Creates an immutable Phrase entity.
  const Phrase({required this.english, required this.persian});
}

// Example usage:
// const phrase = Phrase(english: 'Day by day it gets better', persian: 'امروز به امروز بهتر می شود');
