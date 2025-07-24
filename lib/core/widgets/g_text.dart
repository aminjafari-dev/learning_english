/// GText is a custom wrapper for the standard Text widget.
///
/// Usage Example:
///   return GText('Hello World', style: Theme.of(context).textTheme.bodyLarge);
///
/// This helps maintain consistent text styling and allows for future customization.
import 'package:flutter/material.dart';

class GText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
