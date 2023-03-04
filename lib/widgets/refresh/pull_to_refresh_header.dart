// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/cupertino.dart' hide RefreshIndicatorMode;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    hide CupertinoActivityIndicator;

import '../../extensions/build_context_extension.dart';
import '../tapper.dart';

class PullToRefreshHeader extends StatelessWidget {
  const PullToRefreshHeader({
    Key? key,
    this.info,
    this.textStyle,
  }) : super(key: key);

  final PullToRefreshScrollNotificationInfo? info;
  final TextStyle? textStyle;

  TextStyle _effectiveTextStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle!;
    }
    return TextStyle(
      color: context.theme.dividerColor.withOpacity(0.375),
      fontSize: 14,
      height: 1.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (info == null) {
      return const SliverToBoxAdapter();
    }

    final double dragOffset = info?.dragOffset ?? 0.0;
    final RefreshIndicatorMode? mode = info?.mode;
    bool isRefreshingMode = false;

    String text;
    switch (mode) {
      case RefreshIndicatorMode.snap:
      case RefreshIndicatorMode.refresh:
        isRefreshingMode = true;
        text = context.l10n.listRefreshing;
        break;
      case RefreshIndicatorMode.armed:
        text = context.l10n.listRefreshArmed;
        break;
      case RefreshIndicatorMode.done:
        text = context.l10n.listRefreshSucceed;
        break;
      case RefreshIndicatorMode.error:
        text = context.l10n.listRefreshFailed;
        break;
      default:
        text = context.l10n.listRefreshWaiting;
        break;
    }

    if (mode == RefreshIndicatorMode.done) {
      widget = const SizedBox.expand();
    } else {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: kTabScrollDuration,
            child: isRefreshingMode
                ? CupertinoActivityIndicator(animating: isRefreshingMode)
                : const SizedBox.shrink(),
          ),
          AnimatedContainer(
            duration: kTabScrollDuration,
            width: isRefreshingMode ? 10 : 0,
          ),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }

    widget = SizedBox(height: dragOffset, child: widget);

    if (mode == RefreshIndicatorMode.error) {
      widget = Tapper(
        onTap: () => info?.pullToRefreshNotificationState.show(),
        child: SizedBox(
          height: dragOffset,
          child: Center(child: Text(context.l10n.listNetworkErrorClickRetry)),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: DefaultTextStyle(
        style: _effectiveTextStyle(context),
        child: widget,
      ),
    );
  }
}
