/// GGap class provides standardized spacing widgets for vertical and horizontal gaps.
///
/// Usage Example:
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         Text('Above'),
///         GGap.g16, // 16px gap
///         Text('Below'),
///       ],
///     );
///   }
///
/// This helps maintain consistent spacing and improves readability.
import 'package:gap/gap.dart';

class GGap {
  const GGap();
  // Vertical gaps
  static const g4 = Gap(4);
  static const g8 = Gap(8);
  static const g12 = Gap(12);
  static const g16 = Gap(16);
  static const g24 = Gap(24);
  static const g32 = Gap(32);

}
