/// GButton is a custom wrapper for the standard ElevatedButton widget.
///
/// Usage Example:
///   return GButton(
///     text: 'Sign In',
///     onPressed: () {},
///   );
///
/// This helps maintain consistent button styling and allows for future customization.
import 'package:flutter/material.dart';
import 'g_text.dart';

class GButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;

  const GButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child:
          icon == null
              ? GText(text)
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), GText(text)],
              ),
    );
  }
}
