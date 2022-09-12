// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/widgets.dart' show Characters;

final mobileRegExp = RegExp(r'^1[3-9]\d{9}$');
final emailRegExp = RegExp(
  r'^[a-z][0-9a-z\-_ \.]*@([a-z0-9]+\.)+?[a-z]+$',
  caseSensitive: false,
);

extension StringExtension on String {
  String get notBreak => Characters(this).join('\u{200B}');

  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);

  String removeAll(Pattern pattern) => replaceAll(pattern, '');

  String removeFirst(Pattern pattern, [int startIndex = 0]) =>
      replaceFirst(pattern, '', startIndex);

  bool isMobile() => mobileRegExp.hasMatch(this);

  bool isEmail() => emailRegExp.hasMatch(this);
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  int? toIntOrNull() => this == null ? null : int.tryParse(this!);

  double? toDoubleOrNull() => this == null ? null : double.tryParse(this!);
}

/// Try with the DartPad:
/// https://dartpad.cn/?id=98317a28d0cc65f63454c0329f5316ba
///
/// Thanks to @DemoJameson .
extension EncryptStringExtension on String {
  String get toEncrypted {
    return split('')
        .map((String e) {
          final int ascii = e.codeUnitAt(0);
          final int r = ascii % 8;
          final int offset =
              <int, int>{2: 7, 3: 6, 0: 5, 1: 4, 6: 3, 7: 2, 4: 1, 5: 0}[r]!;
          return (ascii + offset - r).toRadixString(16);
        })
        .join()
        .toLowerCase();
  }
}
