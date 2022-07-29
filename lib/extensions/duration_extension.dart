// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'build_context_extension.dart';

extension DurationExtension on Duration {
  Future<void> get delay => Future<void>.delayed(this);

  String differenceString(BuildContext context) {
    final localization = context.l10n;
    if (this >= const Duration(days: 365)) {
      return localization.durationYears(inDays ~/ 365);
    }
    if (this >= const Duration(days: 30)) {
      return localization.durationMonths(inDays ~/ 30);
    }
    if (this >= const Duration(days: 1)) {
      return localization.durationDays(inDays);
    }
    if (this >= const Duration(hours: 1)) {
      return localization.durationHours(inHours);
    }
    return localization.durationMinutes(math.max(0, inMinutes));
  }
}
