// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:juejin/l10n/gen/jj_localizations.dart';

extension DurationExtension on Duration {
  Future<void> get delay => Future<void>.delayed(this);

  String get differenceString {
    int count;
    String unit;
    final Locale currentLocale = Locale(Intl.shortLocale(Platform.localeName));
    final JJLocalizations localizations = lookupJJLocalizations(currentLocale);
    String space = '';
    if (localizations.localeName.toLowerCase() == 'en') {
      space = ' ';
    }

    if (this >= const Duration(days: 365)) {
      count = inDays ~/ 365;
      unit = localizations.years;
      if (localizations.localeName.toLowerCase() == 'en' && count > 1) {
        unit += 's';
      }
    } else if (this >= const Duration(days: 30)) {
      count = inDays ~/ 30;
      unit = localizations.months;
      if (localizations.localeName.toLowerCase() == 'en' && count > 1) {
        unit += 's';
      }
    } else if (this >= const Duration(days: 1)) {
      count = inDays;
      unit = localizations.days;
      if (localizations.localeName.toLowerCase() == 'en' && count > 1) {
        unit += 's';
      }
    } else if (this >= const Duration(hours: 1)) {
      count = inHours;
      unit = localizations.hours;
      if (localizations.localeName.toLowerCase() == 'en' && count > 1) {
        unit += 's';
      }
    } else {
      count = math.max(1, inMinutes);
      unit = localizations.months;
      if (localizations.localeName.toLowerCase() == 'en' && count > 1) {
        unit += 's';
      }
    }
    return '$count$space$unit$space${localizations.ago}';
  }
}
