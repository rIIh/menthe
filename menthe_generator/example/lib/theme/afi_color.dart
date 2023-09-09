import 'dart:ui';

final class AFIColor {
  final Color light; // automatically mapped to `light` variant.
  final Color dark; // automatically mapped to `dark` variant.

  const AFIColor.single(Color color)
      : light = color,
        dark = color;

  const AFIColor({required this.light, required this.dark});
}
