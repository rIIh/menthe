import 'package:example/theme/pt_color.dart';
import 'package:flutter/material.dart';
import 'package:menthe_annotation/menthe_annotation.dart';

part 'color_theme.g.dart';

@Menthe(extensionGetter: 'ptColors')
abstract final class $PTColorTheme {
  static const primary = PTColor.single(Colors.red);
  static final background =
      PTColor(light: Colors.white, dark: Colors.grey.shade900);
}
