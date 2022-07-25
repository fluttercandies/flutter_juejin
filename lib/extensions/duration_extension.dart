// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:math' as math;

extension DurationExtension on Duration {
  Future<void> get delay => Future<void>.delayed(this);

  String get differenceString {
    final int count;
    final String unit;
    if (this >= const Duration(days: 365)) {
      count = inDays ~/ 365;
      unit = '年';
    } else if (this >= const Duration(days: 30)) {
      count = inDays ~/ 30;
      unit = '月';
    } else if (this >= const Duration(days: 1)) {
      count = inDays;
      unit = '天';
    } else if (this >= const Duration(hours: 1)) {
      count = inHours;
      unit = '小时';
    } else {
      count = math.max(1, inMinutes);
      unit = '分钟';
    }
    return '$count$unit前';
  }
}
