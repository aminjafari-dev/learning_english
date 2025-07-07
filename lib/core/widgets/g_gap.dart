/// GGap class provides standardized spacing widgets for vertical and horizontal gaps.
///
/// Usage Example:
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         Text('Above'),
///         GGap.v16, // 16px vertical gap
///         Text('Below'),
///       ],
///     );
///   }
///
/// This helps maintain consistent spacing and improves readability.
import 'package:flutter/widgets.dart';

class GGap {
 const GGap();
  // Vertical gaps
  static const v4 = SizedBox(height: 4);
  static const v8 = SizedBox(height: 8);
  static const v12 = SizedBox(height: 12);
  static const v16 = SizedBox(height: 16);
  static const v24 = SizedBox(height: 24);
  static const v32 = SizedBox(height: 32);

  // Horizontal gaps
  static const h4 = SizedBox(width: 4);
  static const h8 = SizedBox(width: 8);
  static const h12 = SizedBox(width: 12);
  static const h16 = SizedBox(width: 16);
  static const h24 = SizedBox(width: 24);
  static const h32 = SizedBox(width: 32);
}
