// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildOKToast({required Widget child}) {
    return OKToast(
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom.copyWith(
        offset: -Screens.mediaQuery.size.height / 12,
      ),
      radius: 5,
      child: child,
    );
  }

  Widget _buildAnnotatedRegion(BuildContext context, Widget child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.brightness.isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
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
  Widget build(BuildContext context) {
    return _buildOKToast(
      child: MaterialApp(
        theme: themeBy(brightness: Brightness.light),
        darkTheme: themeBy(brightness: Brightness.dark),
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
              context.l10n.exceptionRouteNotFound(
                settings.name ?? context.l10n.exceptionRouteUnknown,
              ),
              style: const TextStyle(color: Colors.white, inherit: false),
            ),
          ),
        ),
        localizationsDelegates: JJLocalizations.localizationsDelegates,
        supportedLocales: JJLocalizations.supportedLocales,
        scrollBehavior: _ScrollBehavior(),
        builder: (BuildContext context, Widget? child) => Stack(
          children: <Widget>[
            _buildAnnotatedRegion(context, child!),
            _buildBottomPaddingVerticalShield(context),
          ],
        ),
      ),
    );
  }
}

class _ScrollBehavior extends MaterialScrollBehavior {
  /// do not wrapper a [Scrollbar] on desktop platforms
  /// That will cause scroll position error with multi scrollables
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
