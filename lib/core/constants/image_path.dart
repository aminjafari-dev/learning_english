/// ImagePath class centralizes all image asset paths for easy reference and maintainability.
///
/// Usage Example:
///   Image.asset(ImagePath.googleLogo)
///
/// This helps avoid hardcoding asset paths throughout the codebase.
class ImagePath {
  static const String learnEnglishBook = 'assets/images/learn_english_book.png';
  static const String googleLogo =
      'assets/images/google_logo.png'; // Add this asset if needed

  // Level selection images
  static const String beginnerImage = 'assets/images/biginner_image.png';
  static const String elementaryImage = 'assets/images/elementry_image.png';
  static const String intermediateImage =
      'assets/images/intermediate_image.png';
  static const String advancedImage = 'assets/images/advanced_image.png';
}
