// vocabulary.dart
// Entity representing a vocabulary item in the domain layer.

class Vocabulary {
  final String english;
  final String persian;

  /// Creates an immutable Vocabulary entity.
  const Vocabulary({required this.english, required this.persian});
}

// Example usage:
// const vocab = Vocabulary(english: 'Lesson', persian: 'درس');
