// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'exports.dart';
import 'internals/navigator_observer.dart';
import 'routes/juejin_route.dart';

class JJApp extends StatefulWidget {
  const JJApp({super.key});

  @override
  State<JJApp> createState() => JJAppState();
}

class JJAppState extends State<JJApp> with WidgetsBindingObserver {
  Brightness get platformBrightness => WidgetsBinding.instance.window.platformBrightness;

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

  Widget _buildAnnotatedRegion({required Widget child}) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: platformBrightness.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: child,
    );
  }

  Widget _buildBottomPaddingVerticalShield(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      end: 0,
      bottom: 0,
      height: MediaQuery.of(context).padding.bottom,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: (_) {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildOKToast(
      child: _buildAnnotatedRegion(
        child: MaterialApp(
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
          onGenerateTitle: (BuildContext c) => c.l10n.appTitle,
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(
            settings: settings,
            getRouteSettings: getRouteSettings,
            notFoundPageBuilder: () => Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: Text(
                '${settings.name ?? context.l10n.exceptionRouteUnknown}'
                '${context.l10n.exceptionRouteNotFound}',
                style: const TextStyle(color: Colors.white, inherit: false),
              ),
            ),
          ),
          localizationsDelegates: JJLocalizations.localizationsDelegates,
          supportedLocales: JJLocalizations.supportedLocales,
          builder: (BuildContext context, Widget? child) => Stack(
            children: <Widget>[
              child!,
              _buildBottomPaddingVerticalShield(context),
            ],
          ),
        ),
      ),
    );
  }
}
