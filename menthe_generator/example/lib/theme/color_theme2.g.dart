// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_theme2.dart';

// **************************************************************************
// MentheGenerator
// **************************************************************************

class AFIColorTheme extends ThemeExtension<AFIColorTheme> {
  AFIColorTheme({
    required this.primary,
    required this.background,
  });

  factory AFIColorTheme.light() => _kLight;

  factory AFIColorTheme.dark() => _kDark;

  static AFIColorTheme _kLight = AFIColorTheme(
    primary: _AFIColorTheme.primary.light,
    background: _AFIColorTheme.background.light,
  );

  static AFIColorTheme _kDark = AFIColorTheme(
    primary: _AFIColorTheme.primary.dark,
    background: _AFIColorTheme.background.dark,
  );

  /// See [_AFIColorTheme.primary]
  final Color primary;

  /// See [_AFIColorTheme.background]
  final Color background;

  AFIColorTheme copyWith({
    Color? primary,
    Color? background,
  }) {
    return AFIColorTheme(
      primary: primary ?? this.primary,
      background: background ?? this.background,
    );
  }

  AFIColorTheme lerp(
    covariant AFIColorTheme? other,
    double t,
  ) {
    return AFIColorTheme(
      primary: Color.lerp(primary, other?.primary, t)!,
      background: Color.lerp(background, other?.background, t)!,
    );
  }
}

extension AFIColorThemeX on ThemeData {
  AFIColorTheme get afiColors => extension<AFIColorTheme>()!;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
