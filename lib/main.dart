// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';

import 'package:dio/dio.dart' show DioError, DioErrorType;
import 'package:flutter/material.dart';

import 'app.dart';
import 'exports.dart';

void main() {
  runZonedGuarded<void>(
    () async {
      JJErrorWidget.takeOver();
      runApp(JJApp(key: JJ.appKey));
    },
    (Object e, StackTrace s) {
      if (e is ModelError) {
        return;
      }
      if (e is DioError && e.type == DioErrorType.cancel) {
        return;
      }
      HapticUtil.notifyFailure();
      LogUtil.e(
        'Caught unhandled exception: $e',
        stackTrace: s,
        tag: '💂 runZonedGuard',
      );
      showErrorToast('$e');
    },
  );
}
