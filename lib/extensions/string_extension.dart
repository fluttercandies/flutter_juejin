// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/widgets.dart' show Characters;

extension StringExtension on String {
  String get notBreak => Characters(this).join('\u{200B}');

  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);

  String removeAll(Pattern pattern) => replaceAll(pattern, '');

  String removeFirst(Pattern pattern, [int startIndex = 0]) =>
      replaceFirst(pattern, '', startIndex);
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  int? toIntOrNull() => this == null ? null : int.tryParse(this!);

  double? toDoubleOrNull() => this == null ? null : double.tryParse(this!);
}
