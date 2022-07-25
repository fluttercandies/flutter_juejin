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
  /// 通过时间戳返回 `9小时15分6秒` 格式的时间字符串
  String get durationString {
    final Duration duration = Duration(seconds: this);
    if (this >= 3600) {
      final Duration hour = Duration(hours: duration.inHours);
      final Duration minute = Duration(minutes: duration.inMinutes) - hour;
      final Duration second =
          Duration(seconds: duration.inSeconds) - hour - minute;
      return '${hour.inHours}小时${minute.inMinutes}分${second.inSeconds}秒';
    } else if (this >= 60 && this < 3600) {
      final Duration minute = Duration(minutes: duration.inMinutes);
      final Duration second = Duration(seconds: duration.inSeconds) - minute;
      return '${minute.inMinutes}分${second.inSeconds}秒';
    } else {
      return '$this秒';
    }
  }

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
