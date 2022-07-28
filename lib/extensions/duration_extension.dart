import 'dart:math' as math;

import '../l10n/gen/jj_localizations.dart';
import '../l10n/gen/jj_localizations_zh.dart';

extension DurationExtension on Duration {
  Future<void> get delay => Future<void>.delayed(this);

  String differenceString([JJLocalizations? jjLocalizations]) {
    final localization = jjLocalizations ?? JJLocalizationsZh();
    final int count;
    final String unit;
    if (this >= const Duration(days: 365)) {
      count = inDays ~/ 365;
      if (count > 1) {
        unit = localization.durationYears;
      } else {
        unit = localization.durationYear;
      }
    } else if (this >= const Duration(days: 30)) {
      count = inDays ~/ 30;
      if (count > 1) {
        unit = localization.durationMonths;
      } else {
        unit = localization.durationMonth;
      }
    } else if (this >= const Duration(days: 1)) {
      count = inDays;
      if (count > 1) {
        unit = localization.durationDays;
      } else {
        unit = localization.durationDay;
      }
    } else if (this >= const Duration(hours: 1)) {
      count = inHours;
      if (count > 1) {
        unit = localization.durationHours;
      } else {
        unit = localization.durationHour;
      }
    } else {
      count = math.max(1, inMinutes);
      if (count > 1) {
        unit = localization.durationMinutes;
      } else {
        unit = localization.durationMinute;
      }
    }
    return '$count$unit${localization.durationAgo}';
  }
}