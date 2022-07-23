// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

typedef LogFunction = void Function(
  Object? message,
  String tag,
  StackTrace stackTrace, {
  bool? isError,
  Level? level,
});

typedef Supplier<T> = FutureOr<T> Function();

class LogUtil {
  const LogUtil._();

  static StreamController<LogEvent>? _controller;

  static StreamSubscription<LogEvent> addLogListener(
    void Function(LogEvent event, Stream<LogEvent> stream) onData,
  ) {
    _controller ??= StreamController<LogEvent>.broadcast();
    return _controller!.stream.listen(
      (LogEvent data) => onData(data, _controller!.stream),
    );
  }

  static const String logTag = 'LOG';

  static void i(
    Object? message, {
    String? tag,
    StackTrace? stackTrace,
    int level = 1,
  }) {
    tag = tag ??
        (kDebugMode ? getStackTraceId(StackTrace.current, level) : logTag);
    _printLog(message, '$tag ❕', stackTrace, level: Level.CONFIG);
  }

  static void d(
    Object? message, {
    String? tag,
    StackTrace? stackTrace,
    int level = 1,
  }) {
    tag = tag ??
        (kDebugMode ? getStackTraceId(StackTrace.current, level) : logTag);
    _printLog(message, '$tag 📣', stackTrace, level: Level.INFO);
  }

  static void w(
    Object? message, {
    String? tag,
    StackTrace? stackTrace,
    int level = 1,
  }) {
    tag = tag ??
        (kDebugMode ? getStackTraceId(StackTrace.current, level) : logTag);
    _printLog(message, '$tag ⚠️', stackTrace, level: Level.WARNING);
  }

  static void dd(
    Supplier<Object?> call, {
    String? tag,
    StackTrace? stackTrace,
    int level = 1,
  }) {
    if (kDebugMode) {
      tag = tag ?? getStackTraceId(StackTrace.current, level);
      _printLog(call(), '$tag 👀', stackTrace, level: Level.INFO);
    }
  }

  static String getStackTraceId(StackTrace stackTrace, int level) {
    return stackTrace
        .toString()
        .split('\n')[level]
        .replaceAll(RegExp(r'(#\d+\s+)|(<anonymous closure>)'), '')
        .replaceAll('. (', '.() (');
  }

  static void e(
    Object? message, {
    String? tag,
    StackTrace? stackTrace,
    bool withStackTrace = true,
    int level = 1,
    bool report = true,
  }) {
    tag = tag ??
        (kDebugMode ? getStackTraceId(StackTrace.current, level) : logTag);
    _printLog(
      message,
      '$tag ❌',
      stackTrace,
      isError: true,
      level: Level.SEVERE,
      withStackTrace: withStackTrace,
      report: report,
    );
  }

  static void json(
    Object? message, {
    String? tag,
    StackTrace? stackTrace,
    int level = 1,
  }) {
    tag = tag ??
        (kDebugMode ? getStackTraceId(StackTrace.current, level) : logTag);
    _printLog(message, '$tag 💠', stackTrace);
  }

  static void _printLog(
    Object? message,
    String tag,
    StackTrace? stackTrace, {
    bool isError = false,
    Level level = Level.ALL,
    bool withStackTrace = true,
    bool report = false,
  }) {
    final DateTime time = DateTime.now();
    final String timeString = time.toIso8601String();
    _controller?.add(LogEvent(timeString, tag, message, stackTrace));
    if (isError) {
      if (kDebugMode) {
        FlutterError.presentError(
          FlutterErrorDetails(
            exception: message ?? 'NULL',
            stack: stackTrace,
            library: tag == logTag ? 'Framework' : tag,
          ),
        );
      } else {
        dev.log(
          '$timeString - An error occurred.',
          time: time,
          name: tag,
          level: level.value,
          error: message,
          stackTrace: stackTrace,
        );
      }
    } else {
      dev.log(
        '$timeString - $message',
        time: time,
        name: tag,
        level: level.value,
        stackTrace: stackTrace ??
            (isError && withStackTrace ? StackTrace.current : null),
      );
    }
    // if (report && kReleaseMode) {
    //   BotUtil.reportToBot(_time, level, message, stackTrace);
    // }
  }
}

class LogEvent {
  const LogEvent(this.time, this.tag, this.message, this.stackTrace);

  final String time;
  final String tag;
  final Object? message;
  final StackTrace? stackTrace;
}
