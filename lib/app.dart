// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

import 'exports.dart';
import 'internals/navigator_observer.dart';
import 'routes/juejin_route.dart';

class JJApp extends StatefulWidget {
  const JJApp({super.key});

  @override
  State<JJApp> createState() => JJAppState();
}

class JJAppState extends State<JJApp> {
  Widget _buildOKToast({required Widget child}) {
    return OKToast(
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom.copyWith(
        offset: -MediaQueryData.fromWindow(ui.window).size.height / 12,
      ),
      radius: 5,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildOKToast(
      child: MaterialApp(
        title: '掘金',
        theme: ThemeData(
          primarySwatch: themeColorLight.swatch,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: themeColorLight.swatch,
        ),
        initialRoute: Routes.splashPage.name,
        navigatorKey: JJ.navigatorKey,
        navigatorObservers: <NavigatorObserver>[
          JJ.routeObserver,
          JJNavigatorObserver(),
        ],
        onGenerateRoute: (RouteSettings settings) => onGenerateRoute(
          settings: settings,
          getRouteSettings: getRouteSettings,
          notFoundPageBuilder: () => Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: Text(
              '${settings.name ?? 'Unknown'} route not found.',
              style: const TextStyle(color: Colors.white, inherit: false),
            ),
          ),
        ),
        locale: const Locale('zh'),
        localizationsDelegates: const <LocalizationsDelegate>[
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[Locale('zh')],
      ),
    );
  }
}
