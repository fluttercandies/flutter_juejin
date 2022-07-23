// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';

import '../utils/log_util.dart';

extension FutureExtension<T> on Future<T> {
  Future<T> atLeast(Duration duration) async {
    final List<dynamic> futures = await Future.wait<dynamic>(
      <Future<dynamic>>[this, Future<void>.delayed(duration)],
    );
    return futures.first as T;
  }

  Future<List<T>> plus(Future<T> b, {bool eagerError = false}) {
    return Future.wait(<Future<T>>[this, b], eagerError: eagerError);
  }
}

extension StopwatchExtension on Stopwatch {
  void logElapsed([String? tag]) {
    LogUtil.d(
      '${tag ?? 'Stopwatch'} elapsed: $elapsed',
      tag: '⌚ Stopwatch',
    );
  }
}
