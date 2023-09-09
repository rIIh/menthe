import 'package:example/theme/afi_color.dart';
import 'package:flutter/material.dart';
import 'package:menthe_annotation/menthe_annotation.dart';

part 'color_theme2.g.dart';

@Menthe(extensionGetter: 'afiColors')
final class _AFIColorTheme {
  static const primary = AFIColor.single(Colors.red);
  static final background =
      AFIColor(light: Colors.white, dark: Colors.grey.shade900);
}

// gen code

final class AFIColorThemeTemplate
    extends ThemeExtension<AFIColorThemeTemplate> {
  final Color primary;
  final Color background;

  const AFIColorThemeTemplate(
      {required this.primary, required this.background});

  const AFIColorThemeTemplate.light()
      : primary = Colors.red,
        background = Colors.white;

  /* const */ AFIColorThemeTemplate.dark()
      : primary = Colors.red,
        background =
            Colors.grey.shade900; // maybe map to const Color(0xFF....).

  @override
  ThemeExtension<AFIColorThemeTemplate> copyWith({
    Color? primary,
    Color? background,
  }) {
    return AFIColorThemeTemplate(
      primary: primary ?? this.primary,
      background: background ?? this.background,
    );
  }

  @override
  AFIColorThemeTemplate lerp(covariant AFIColorThemeTemplate? other, double t) {
    return AFIColorThemeTemplate(
      primary: Color.lerp(primary, other?.primary, t)!,
      background: Color.lerp(background, other?.background, t)!,
    );
  }
}

extension ThemeX on ThemeData {
  AFIColorThemeTemplate get ptColors => extension<AFIColorThemeTemplate>()!;
}
