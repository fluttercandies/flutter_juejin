// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'exports.dart';

void main() {
  PlatformDispatcher.instance.onError = (e, s) {
    if (e is ModelError) {
      return true;
    }
    if (e is DioException && e.type == DioExceptionType.cancel) {
      return true;
    }
    HapticUtil.notifyFailure();
    LogUtil.e(
      'Caught unhandled exception: $e',
      stackTrace: s,
      tag: '💂 PlatformDispatcher',
    );
    showErrorToast('$e');
    return true;
  };
  JJErrorWidget.takeOver();
  runApp(JJApp(key: JJ.appKey));
}
