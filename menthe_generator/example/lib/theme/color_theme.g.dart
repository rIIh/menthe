// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_theme.dart';

// **************************************************************************
// MentheGenerator
// **************************************************************************

class PTColorTheme extends ThemeExtension<PTColorTheme> {
  PTColorTheme({
    required this.primary,
    required this.background,
  });

  factory PTColorTheme.light() => _kLight;

  factory PTColorTheme.dark() => _kDark;

  static PTColorTheme _kLight = PTColorTheme(
    primary: $PTColorTheme.primary.light,
    background: $PTColorTheme.background.light,
  );

  static PTColorTheme _kDark = PTColorTheme(
    primary: $PTColorTheme.primary.dark,
    background: $PTColorTheme.background.dark,
  );

  /// See [$PTColorTheme.primary]
  final Color primary;

  /// See [$PTColorTheme.background]
  final Color background;

  PTColorTheme copyWith({
    Color? primary,
    Color? background,
  }) {
    return PTColorTheme(
      primary: primary ?? this.primary,
      background: background ?? this.background,
    );
  }

  PTColorTheme lerp(
    covariant PTColorTheme? other,
    double t,
  ) {
    return PTColorTheme(
      primary: Color.lerp(primary, other?.primary, t)!,
      background: Color.lerp(background, other?.background, t)!,
    );
  }
}

extension PTColorThemeX on ThemeData {
  PTColorTheme get ptColors => extension<PTColorTheme>()!;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
