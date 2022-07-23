// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';

import '../app.dart';

class JJ {
  const JJ._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();
  static final GlobalKey repaintBoundaryKey = GlobalKey();
  static final GlobalKey<JJAppState> appKey = GlobalKey();
}

NavigatorState get navigator => JJ.navigatorKey.currentState!;

BuildContext get overlayContext => navigator.overlay!.context;

DateTime get currentTime => DateTime.now();

int get currentTimeStamp => currentTime.millisecondsSinceEpoch;
