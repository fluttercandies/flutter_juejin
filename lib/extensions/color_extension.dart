// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get isTransparent => alpha == 0;

  MaterialColor get swatch {
    return Colors.primaries.firstWhere(
      (Color c) => c.value == value,
      orElse: () => MaterialColor(value, getMaterialColorValues),
    );
  }

  Map<int, Color> get getMaterialColorValues {
    return <int, Color>{
      50: _swatchShade(50),
      100: _swatchShade(100),
      200: _swatchShade(200),
      300: _swatchShade(300),
      400: _swatchShade(400),
      500: _swatchShade(500),
      600: _swatchShade(600),
      700: _swatchShade(700),
      800: _swatchShade(800),
      900: _swatchShade(900),
    };
  }

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this)
      .withLightness(1 - (swatchValue / 1000))
      .toColor();
}

/// https://stackoverflow.com/a/50081214/10064463
extension HexColor on Color {
  /// Format: "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true`.
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
