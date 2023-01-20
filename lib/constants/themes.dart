// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/jj_localizations.dart';

const Color backgroundColorDark = Color(0xff0b0b0f);
const Color backgroundColorLight = Color(0xfff2f2f6);
const Color themeColorDark = Color(0xff007fff);
const Color themeColorLight = themeColorDark;
const Color cardColorDark = Color(0xff181818);
const Color cardColorLight = Colors.white;
const Color dividerColorDark = Color(0xff3a3a49);
const Color dividerColorLight = Color(0xffe8eafd);
const Color iconColorDark = Color(0xff5d5d6c);
const Color iconColorLight = Color(0xff898b97);
const Color listColorDark = Color(0xff15151d);
const Color listColorLight = Color(0xfff2f2f2);
const Color headlineTextColorDark = Colors.white;
const Color headlineTextColorLight = Colors.black;
const Color primaryTextColorDark = Colors.white70;
const Color primaryTextColorLight = Color(0xff555557);
const Color captionTextColorDark = Color(0xff9c9ca4);
const Color captionTextColorLight = captionTextColorDark;

ThemeData themeBy({
  required Brightness brightness,
  Locale? locale,
}) {
  locale ??= basicLocaleListResolution(
    JJLocalizations.supportedLocales,
    JJLocalizations.supportedLocales,
  );
  final JJTheme tg = JJTheme.fromBrightness(brightness);
  final ThemeData theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: tg.themeColor,
      brightness: brightness,
      primary: tg.cardColor,
      background: tg.backgroundColor,
    ),
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[tg],
    primaryColor: tg.themeColor,
    cardColor: tg.cardColor,
    canvasColor: tg.listColor,
    dividerColor: tg.dividerColor,
    appBarTheme: AppBarTheme(
      color: tg.cardColor,
      elevation: 0.5,
      iconTheme: IconThemeData(color: tg.primaryTextColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: tg.cardColor,
      selectedItemColor: tg.themeColor,
      unselectedItemColor: tg.iconColor,
    ),
    iconTheme: IconThemeData(color: tg.iconColor),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      hintStyle: TextStyle(color: tg.iconColor),
    ),
    scaffoldBackgroundColor: tg.backgroundColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: tg.themeColor,
      selectionColor: tg.themeColor.withOpacity(.25),
      selectionHandleColor: tg.themeColor,
    ),
    textTheme: _textThemeBy(themeGroup: tg, locale: locale),
  );
  return theme;
}

TextTheme _textThemeBy({
  required JJTheme themeGroup,
  required Locale locale,
}) {
  final bool isCJK = locale.languageCode == 'zh' ||
      locale.languageCode == 'ja' ||
      locale.languageCode == 'kr';
  final TextStyle baseStyle = TextStyle(
    fontFamily: !isCJK ? 'PT Sans' : null,
    fontFamilyFallback: const <String>['PingFang SC', 'Heiti SC'],
    fontWeight: FontWeight.normal,
    height: isCJK ? 1.24 : 1,
    leadingDistribution: TextLeadingDistribution.even,
    textBaseline: isCJK ? TextBaseline.ideographic : TextBaseline.alphabetic,
  );
  final TextStyle displayTextStyle = baseStyle.copyWith(
    color: themeGroup.captionTextColor,
  );
  final TextStyle headlineTextStyle = baseStyle.copyWith(
    color: themeGroup.headlineTextColor,
    fontWeight: FontWeight.bold,
  );
  final TextStyle primaryTextStyle = baseStyle.copyWith(
    color: themeGroup.primaryTextColor,
  );
  final TextStyle captionTextStyle = baseStyle.copyWith(
    color: themeGroup.captionTextColor,
  );
  final Typography typography = Typography.material2014(
    platform: defaultTargetPlatform,
  );
  final TextTheme baseTextTheme = themeGroup.brightness == Brightness.dark
      ? typography.white
      : typography.black;
  return baseTextTheme.merge(
    TextTheme(
      displayLarge: displayTextStyle,
      displayMedium: displayTextStyle,
      displaySmall: displayTextStyle,
      headlineLarge: headlineTextStyle.copyWith(fontSize: 28),
      headlineMedium: headlineTextStyle.copyWith(fontSize: 24),
      headlineSmall: headlineTextStyle.copyWith(fontSize: 20),
      titleLarge: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
      titleMedium: primaryTextStyle,
      titleSmall: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
      bodyLarge: primaryTextStyle,
      bodyMedium: primaryTextStyle,
      bodySmall: captionTextStyle,
      labelLarge: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
      labelMedium: primaryTextStyle,
      labelSmall: primaryTextStyle,
    ),
  );
}

const JJTheme defaultThemeGroupDark = JJTheme(
  brightness: Brightness.dark,
  themeColor: themeColorDark,
  backgroundColor: backgroundColorDark,
  cardColor: cardColorDark,
  dividerColor: dividerColorDark,
  iconColor: iconColorDark,
  listColor: listColorDark,
  headlineTextColor: headlineTextColorDark,
  primaryTextColor: primaryTextColorDark,
  captionTextColor: captionTextColorDark,
);

const JJTheme defaultThemeGroupLight = JJTheme(
  brightness: Brightness.light,
  themeColor: themeColorLight,
  backgroundColor: backgroundColorLight,
  cardColor: cardColorLight,
  dividerColor: dividerColorLight,
  iconColor: iconColorLight,
  listColor: listColorLight,
  headlineTextColor: headlineTextColorLight,
  primaryTextColor: primaryTextColorLight,
  captionTextColor: captionTextColorLight,
);

class JJTheme extends ThemeExtension<JJTheme> {
  const JJTheme({
    required this.brightness,
    required this.themeColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.dividerColor,
    required this.iconColor,
    required this.listColor,
    required this.headlineTextColor,
    required this.primaryTextColor,
    required this.captionTextColor,
  });

  factory JJTheme.fromBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return defaultThemeGroupDark;
    }
    return defaultThemeGroupLight;
  }

  final Brightness brightness;
  final Color themeColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color dividerColor;
  final Color iconColor;
  final Color listColor;
  final Color headlineTextColor;
  final Color primaryTextColor;
  final Color captionTextColor;

  @override
  ThemeExtension<JJTheme> copyWith({
    Brightness? brightness,
    Color? backgroundColor,
    Color? themeColor,
    Color? cardColor,
    Color? dividerColor,
    Color? iconColor,
    Color? listColor,
    Color? headlineTextColor,
    Color? primaryTextColor,
    Color? captionTextColor,
  }) {
    return JJTheme(
      brightness: brightness ?? this.brightness,
      themeColor: themeColor ?? this.themeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
      dividerColor: dividerColor ?? this.dividerColor,
      iconColor: iconColor ?? this.iconColor,
      listColor: listColor ?? this.listColor,
      headlineTextColor: headlineTextColor ?? this.headlineTextColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      captionTextColor: captionTextColor ?? this.captionTextColor,
    );
  }

  Color _lerp(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  @override
  ThemeExtension<JJTheme> lerp(ThemeExtension<JJTheme>? other, double t) {
    if (other is! JJTheme) {
      return this;
    }
    return JJTheme(
      brightness: brightness == other.brightness
          ? brightness
          : t > 0.5
              ? other.brightness
              : brightness,
      themeColor: _lerp(themeColor, other.themeColor, t),
      backgroundColor: _lerp(backgroundColor, other.backgroundColor, t),
      cardColor: _lerp(cardColor, other.cardColor, t),
      dividerColor: _lerp(dividerColor, other.dividerColor, t),
      iconColor: _lerp(iconColor, other.iconColor, t),
      listColor: _lerp(listColor, other.listColor, t),
      headlineTextColor: _lerp(headlineTextColor, other.headlineTextColor, t),
      primaryTextColor: _lerp(primaryTextColor, other.primaryTextColor, t),
      captionTextColor: _lerp(captionTextColor, other.captionTextColor, t),
    );
  }
}
