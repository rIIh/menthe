import 'dart:ui';

final class PTColor {
  final Color light; // automatically mapped to `light` variant.
  final Color dark; // automatically mapped to `dark` variant.

  const PTColor.single(Color color)
      : light = color,
        dark = color;

  const PTColor({required this.light, required this.dark});
}
