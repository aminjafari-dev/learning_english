/// Font constants for the application
///
/// This file defines font family names and styles used throughout the app.
/// It centralizes font definitions to ensure consistency and make it easier
/// to update fonts globally.
///
/// Usage Example:
///   Text(
///     'سلام دنیا',
///     style: TextStyle(fontFamily: FontConstants.persianFont),
///   )
class FontConstants {
  /// Persian font family name
  ///
  /// This is the primary font for Persian text rendering.
  /// It provides better support for Persian characters and RTL text.
  static const String persianFont = 'BYekan';

  /// Default font family for English text
  ///
  /// This is used as a fallback for English text or when Persian font
  /// is not available.
  static const String defaultFont = 'Roboto';

  /// Shabnam font family name
  ///
  /// This is an alternative Persian font with multiple weights.
  /// It provides excellent readability and modern design for Persian text.
  static const String shabnamFont = 'Shabnam';

  /// Font family for headings and titles
  ///
  /// This can be used for special headings that need different styling
  /// from the regular text.
  static const String headingFont = 'BYekan';

  /// Font family for body text
  ///
  /// This is used for main content text with good readability.
  static const String bodyFont = 'Shabnam';
}
