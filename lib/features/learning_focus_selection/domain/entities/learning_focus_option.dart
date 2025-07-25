/// Entity representing a learning focus option in the domain layer.
///
/// Usage Example:
///   final option = LearningFocusOption(id: 1, title: 'Business English', icon: 'work');
class LearningFocusOption {
  final int id;
  final String title;
  final String icon; // Store icon name or asset path for flexibility

  const LearningFocusOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}
