// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:math' as math;

final math.Random _random = math.Random();

extension NumExtension<T extends num> on T {
  T get lessThanOne => math.min<T>((this is int ? 1 : 1.0) as T, this);

  T get lessThanZero => math.min<T>((this is int ? 0 : 0.0) as T, this);

  T get moreThanOne => math.max<T>((this is int ? 1 : 1.0) as T, this);

  T get moreThanZero => math.max<T>((this is int ? 0 : 0.0) as T, this);

  T get betweenZeroAndOne => lessThanOne.moreThanZero;
}

extension IntExtension on int {
  String get fileSizeFromBytes {
    const int kb = 1024;
    const int mb = 1024 * kb;
    const int gb = 1024 * mb;
    if (this >= gb) {
      return '${(this / gb).toStringAsFixed(2)} GB';
    }
    if (this >= mb) {
      return '${(this / mb).toStringAsFixed(2)} MB';
    }
    if (this >= kb) {
      return '${(this / kb).toStringAsFixed(2)} KB';
    }
    return '$this B';
  }

  int nextRandom([int min = 0]) => min + _random.nextInt(this - min);

  Duration get days => Duration(days: this);

  Duration get hours => Duration(hours: this);

  Duration get minutes => Duration(minutes: this);

  Duration get seconds => Duration(seconds: this);

  Duration get milliseconds => Duration(milliseconds: this);

  Duration get microseconds => Duration(microseconds: this);

  DateTime get toDateTimeInMicroseconds =>
      DateTime.fromMicrosecondsSinceEpoch(this);

  DateTime get toDateTimeInMilliseconds =>
      DateTime.fromMillisecondsSinceEpoch(this);
}

extension DoubleExtension on double {
  double nextRandom([int min = 0]) => min + _random.nextDouble() * (this - min);

  /// 根据位数四舍五入
  double roundAsFixed(int size) {
    final num pow = math.pow(10, size);
    return (this * pow).round() / pow;
  }
}
