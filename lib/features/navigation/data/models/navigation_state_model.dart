/// NavigationStateModel represents the data transfer object for navigation state.
///
/// This model handles the conversion between JSON data and the domain entity
/// for navigation state, including serialization and deserialization.
///
/// Usage Example:
///   final model = NavigationStateModel.fromJson(jsonData);
///   final entity = model.toDomain();
import 'package:learning_english/features/navigation/domain/entities/navigation_state.dart';

/// Data model for navigation state information
class NavigationStateModel {
  /// Current selected tab index
  final int currentIndex;

  /// User ID for storing navigation preferences
  final String userId;

  /// Timestamp when the navigation state was last updated (as ISO string)
  final String lastUpdated;

  /// Constructor for NavigationStateModel
  ///
  /// Parameters:
  ///   - currentIndex: The currently selected tab index
  ///   - userId: The unique identifier of the user
  ///   - lastUpdated: When the state was last updated (as ISO string)
  const NavigationStateModel({
    required this.currentIndex,
    required this.userId,
    required this.lastUpdated,
  });

  /// Creates NavigationStateModel from JSON data
  factory NavigationStateModel.fromJson(Map<String, dynamic> json) {
    return NavigationStateModel(
      currentIndex: json['currentIndex'] as int? ?? 0,
      userId: json['userId'] as String,
      lastUpdated:
          json['lastUpdated'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  /// Converts NavigationStateModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'currentIndex': currentIndex,
      'userId': userId,
      'lastUpdated': lastUpdated,
    };
  }

  /// Converts NavigationStateModel to domain entity
  NavigationState toDomain() {
    DateTime? parsedLastUpdated;
    try {
      parsedLastUpdated = DateTime.parse(lastUpdated);
    } catch (e) {
      parsedLastUpdated = DateTime.now();
    }

    return NavigationState(
      currentIndex: currentIndex,
      userId: userId,
      lastUpdated: parsedLastUpdated,
    );
  }

  /// Creates a copy of this NavigationStateModel with updated values
  NavigationStateModel copyWith({
    int? currentIndex,
    String? userId,
    String? lastUpdated,
  }) {
    return NavigationStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      userId: userId ?? this.userId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationStateModel &&
        other.currentIndex == currentIndex &&
        other.userId == userId &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return currentIndex.hashCode ^ userId.hashCode ^ lastUpdated.hashCode;
  }

  @override
  String toString() {
    return 'NavigationStateModel(currentIndex: $currentIndex, userId: $userId, lastUpdated: $lastUpdated)';
  }
}
