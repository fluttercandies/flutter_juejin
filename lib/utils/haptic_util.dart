// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticUtil {
  const HapticUtil._();

  static Future<void> notifySuccess() {
    return _shouldUseHapticWrapper(
      () => _sequenceWithGap(
        haptics: <Future<void> Function()>[
          HapticFeedback.mediumImpact,
          HapticFeedback.heavyImpact,
        ],
        gapInMilliseconds: 150,
      ),
    );
  }

  static Future<void> notifyWarning() {
    return _shouldUseHapticWrapper(
      () => _sequenceWithGap(
        haptics: <Future<void> Function()>[
          HapticFeedback.heavyImpact,
          HapticFeedback.mediumImpact,
        ],
        gapInMilliseconds: 200,
      ),
    );
  }

  static Future<void> notifyFailure() {
    return _shouldUseHapticWrapper(
      () => _sequenceWithGap(
        haptics: <Future<void> Function()>[
          HapticFeedback.mediumImpact,
          HapticFeedback.mediumImpact,
          HapticFeedback.heavyImpact,
          HapticFeedback.lightImpact,
        ],
        gapInMilliseconds: 100,
      ),
    );
  }

  static Future<void> _sequenceWithGap({
    required List<Future<void> Function()> haptics,
    required int gapInMilliseconds,
  }) async {
    for (int i = 0; i < haptics.length * 2 - 1; i++) {
      if (i.isOdd) {
        await Future<void>.delayed(Duration(milliseconds: gapInMilliseconds));
        continue;
      }
      await haptics[i ~/ 2]();
    }
  }

  static bool get _shouldUseHaptic =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static Future<void> _shouldUseHapticWrapper(Future<void> Function() fn) {
    if (_shouldUseHaptic) {
      return fn();
    }
    return SynchronousFuture<void>(null);
  }
}
