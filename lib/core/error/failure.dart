// failure.dart
// Base and specific failure classes for error handling.

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
    : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
    : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed'])
    : super(message);
}

class GeminiApiFailure extends Failure {
  const GeminiApiFailure([String message = 'Gemini API error occurred'])
    : super(message);
}

class GeminiParsingFailure extends Failure {
  const GeminiParsingFailure([
    String message = 'Failed to parse Gemini response',
  ]) : super(message);
}

class GeminiRateLimitFailure extends Failure {
  const GeminiRateLimitFailure([
    String message = 'Gemini API rate limit exceeded',
  ]) : super(message);
}

class GeminiQuotaExceededFailure extends Failure {
  const GeminiQuotaExceededFailure([
    String message = 'Gemini API quota exceeded',
  ]) : super(message);
}
