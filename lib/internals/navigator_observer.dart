import 'package:flutter/material.dart';

import '../utils/log_util.dart';

enum RouteAction { pop, push, remove, replace }

class JJNavigatorObserver extends NavigatorObserver {
  static final List<Route<dynamic>> history = <Route<dynamic>>[];

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _didRouteChange(RouteAction.pop, previousRoute, route);
    history.removeLast();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _didRouteChange(RouteAction.push, route, previousRoute);
    history.add(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _didRouteChange(RouteAction.remove, previousRoute, route);
    final bool removed = history.remove(route);
    if (!removed) {
      history.removeLast();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _didRouteChange(RouteAction.replace, newRoute, oldRoute);
    if (oldRoute != null) {
      final int index = history.indexOf(oldRoute);
      if (index != -1) {
        if (newRoute == null) {
          history.remove(oldRoute);
        } else {
          history[index] = newRoute;
        }
      }
    } else if (oldRoute == null && newRoute != null) {
      history.add(newRoute);
    }
  }

  void _didRouteChange(
    RouteAction action,
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  ) {
    LogUtil.dd(
      () => '[${action.name.toUpperCase().padLeft(7)}] '
          '${oldRoute?.settings.name} => ${newRoute?.settings.name}',
      tag: runtimeType.toString(),
    );
  }
}
