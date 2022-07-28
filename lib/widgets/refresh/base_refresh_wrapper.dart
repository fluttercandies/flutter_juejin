// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    hide CupertinoActivityIndicator;

import '../../constants/resources.dart';
import '../../constants/screens.dart';
import '../../models/data_model.dart';
import '../../models/loading_base.dart';
import '../gaps.dart';
import '../tapper.dart';
import 'pull_to_refresh_header.dart';

typedef RefreshIndicatorBuilder = Widget? Function(
  BuildContext context,
  IndicatorStatus status,
);
typedef RefreshItemBuilder<T extends DataModel> = Widget Function(T model);
typedef RefreshPackageBuilder = String? Function(bool isError);
typedef RefreshIndicatorWidthBuilder = double? Function(bool isError);
typedef RefreshPlaceholderBuilder = Widget Function(bool isError);
typedef RefreshResourceBuilder = String Function(bool isError);
typedef RefreshSliversBuilder = List<Widget> Function(
  BuildContext context,
  Widget refreshHeader,
  Widget loadingList,
);

typedef RefreshHeaderBuilder = Widget Function(
  BuildContext context,
  PullToRefreshScrollNotificationInfo? info,
);

const double maxDragOffset = 60;

abstract class BaseRefreshWrapper<T extends DataModel> extends StatelessWidget {
  const BaseRefreshWrapper({
    Key? key,
    required this.loadingBase,
    required this.itemBuilder,
    this.sliversBuilder,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.enableRefresh = true,
    this.padding,
    this.shouldIndicatorFillRemaining = true,
    this.indicatorBuilder,
    this.indicatorPlaceholder,
    this.indicatorIcon,
    this.indicatorPackage,
    this.indicatorText,
    this.indicatorTextStyle,
    this.indicatorWidth,
    this.refreshHeaderBuilder,
    this.refreshHeaderTextStyle,
    this.lastChildLayoutType = LastChildLayoutType.fullCrossAxisExtent,
    this.physics,
  }) : super(key: key);

  final LoadingBase<T> loadingBase;
  final RefreshItemBuilder<T> itemBuilder;
  final RefreshSliversBuilder? sliversBuilder;
  final ScrollController? controller;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  final bool shouldIndicatorFillRemaining;
  final RefreshIndicatorBuilder? indicatorBuilder;
  final RefreshPlaceholderBuilder? indicatorPlaceholder;
  final RefreshResourceBuilder? indicatorIcon;
  final RefreshPackageBuilder? indicatorPackage;
  final RefreshResourceBuilder? indicatorText;
  final TextStyle? indicatorTextStyle;
  final RefreshIndicatorWidthBuilder? indicatorWidth;

  final RefreshHeaderBuilder? refreshHeaderBuilder;
  final TextStyle? refreshHeaderTextStyle;

  /// 是否启用刷新（默认启用）
  ///
  /// 有一些特殊的场景，需要一个不分页的列表，但需要占位和错误提示，可以设置为 false。
  final bool enableRefresh;

  final LastChildLayoutType lastChildLayoutType;

  SliverListConfig<T> buildConfig(BuildContext context);

  EdgeInsetsGeometry? buildEffectivePadding(BuildContext context) {
    if (padding != null) {
      return padding;
    }
    EdgeInsetsGeometry? effectivePadding = padding;
    if (padding == null) {
      final MediaQueryData mediaQuery = MediaQuery.of(context);
      // Automatically pad sliver with padding from MediaQuery.
      final EdgeInsets mediaQueryHorizontalPadding =
          mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0);
      final EdgeInsets mediaQueryVerticalPadding =
          mediaQuery.padding.copyWith(left: 0.0, right: 0.0);
      // Consume the main axis padding with SliverPadding.
      effectivePadding = scrollDirection == Axis.vertical
          ? mediaQueryVerticalPadding
          : mediaQueryHorizontalPadding;
    }
    return effectivePadding;
  }

  Widget effectiveIndicatorBuilder(
    BuildContext context,
    IndicatorStatus status,
  ) {
    final Widget? builder = indicatorBuilder?.call(context, status);
    if (builder != null) {
      return builder;
    }
    final Widget indicator;
    switch (status) {
      case IndicatorStatus.none:
        indicator = const SizedBox.shrink();
        break;
      case IndicatorStatus.loadingMoreBusying:
        indicator = ListMoreIndicator(
          isSliver: false,
          isRequesting: true,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.fullScreenBusying:
        indicator = ListMoreIndicator(
          isRequesting: true,
          textStyle: indicatorTextStyle,
        );
        break;
      case IndicatorStatus.error:
        indicator = ListEmptyIndicator(
          isSliver: false,
          isError: true,
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          indicatorWidth: indicatorWidth,
          textStyle: indicatorTextStyle,
          shouldIndicatorFillRemaining: shouldIndicatorFillRemaining,
        );
        break;
      case IndicatorStatus.fullScreenError:
        indicator = ListEmptyIndicator(
          isError: true,
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          indicatorWidth: indicatorWidth,
          textStyle: indicatorTextStyle,
          shouldIndicatorFillRemaining: shouldIndicatorFillRemaining,
        );
        break;
      case IndicatorStatus.noMoreLoad:
        if (loadingBase.isOnlyFirstPage) {
          indicator = const SizedBox.shrink();
        } else {
          indicator = ListMoreIndicator(
            isSliver: false,
            textStyle: indicatorTextStyle,
          );
        }
        break;
      case IndicatorStatus.empty:
        indicator = ListEmptyIndicator(
          loadingBase: loadingBase,
          indicator: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          indicatorWidth: indicatorWidth,
          textStyle: indicatorTextStyle,
          shouldIndicatorFillRemaining: shouldIndicatorFillRemaining,
        );
        break;
    }
    return indicator;
  }

  PullToRefreshContainer _effectiveRefreshHeader(BuildContext context) {
    return PullToRefreshContainer((PullToRefreshScrollNotificationInfo? info) {
      if (refreshHeaderBuilder != null) {
        return refreshHeaderBuilder!(context, info);
      }
      return PullToRefreshHeader(
        info: info,
        textStyle: refreshHeaderTextStyle,
      );
    });
  }

  PullToRefreshNotification buildRefreshNotification(Widget child) {
    return PullToRefreshNotification(
      onRefresh: loadingBase.refresh,
      maxDragOffset: maxDragOffset,
      pullBackCurve: Curves.linear,
      pullBackDuration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  List<Widget> _effectiveSliversBuilder(BuildContext context) {
    final Widget refreshHeader = _effectiveRefreshHeader(context);
    final Widget loadingList = LoadingMoreSliverList<T>(buildConfig(context));
    if (sliversBuilder != null) {
      return sliversBuilder!(context, refreshHeader, loadingList);
    }
    return <Widget>[refreshHeader, loadingList];
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LoadingMoreCustomScrollView(
      physics: physics,
      controller: controller,
      scrollDirection: scrollDirection,
      rebuildCustomScrollView: true,
      slivers: _effectiveSliversBuilder(context),
    );
    if (!enableRefresh) {
      return child;
    }
    child = buildRefreshNotification(child);
    return child;
  }
}

class ListMoreIndicator extends StatelessWidget {
  const ListMoreIndicator({
    Key? key,
    this.isSliver = true,
    this.isRequesting = false,
    this.textStyle,
  }) : super(key: key);

  final bool isSliver;
  final bool isRequesting;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    Widget child;
    child = SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedSwitcher(
            duration: kTabScrollDuration,
            child: isRequesting
                ? const CupertinoActivityIndicator()
                : const SizedBox.shrink(),
          ),
          AnimatedContainer(
            duration: kTabScrollDuration,
            width: isRequesting ? 10 : 0,
          ),
          Text(isRequesting ? '加载中...' : '已经到底啦~'),
        ],
      ),
    );
    if (isSliver) {
      child = SliverFillRemaining(child: Center(child: child));
    }
    return DefaultTextStyle(
      style: textStyle ??
          TextStyle(
            color: Theme.of(context).dividerColor.withOpacity(0.375),
            fontSize: 14,
            height: 1.4,
          ),
      child: child,
    );
  }
}

class ListEmptyIndicator extends StatelessWidget {
  const ListEmptyIndicator({
    Key? key,
    this.isSliver = true,
    this.isError = false,
    this.loadingBase,
    this.shouldIndicatorFillRemaining = true,
    this.indicator,
    this.indicatorIcon,
    this.indicatorPackage,
    this.indicatorWidth,
    this.indicatorText,
    this.textStyle,
    this.onTap,
  }) : super(key: key);

  final bool isSliver;
  final bool isError;
  final LoadingBase<dynamic>? loadingBase;
  final bool shouldIndicatorFillRemaining;
  final RefreshPlaceholderBuilder? indicator;
  final RefreshResourceBuilder? indicatorIcon;
  final RefreshPackageBuilder? indicatorPackage;
  final RefreshIndicatorWidthBuilder? indicatorWidth;
  final RefreshResourceBuilder? indicatorText;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  static const String EMPTY_TEXT = '空空如也';
  static const String ERROR_TEXT = '网络出错了~点此重试';

  @override
  Widget build(BuildContext context) {
    final String effectiveIndicatorIcon =
        indicatorIcon?.call(isError) ?? R.ASSETS_BRAND_SVG;
    Widget child;
    String? text = indicatorText?.call(isError);
    text ??= isError ? ERROR_TEXT : EMPTY_TEXT;
    child = Tapper(
      onTap: isError
          ? () {
              if (onTap != null) {
                onTap!();
              } else {
                loadingBase
                  ?..indicatorStatus = IndicatorStatus.fullScreenBusying
                  ..refresh()
                  ..isLoading = true
                  ..setState();
              }
            }
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (indicator != null)
            indicator!(isError)
          else ...<Widget>[
            if (effectiveIndicatorIcon.endsWith('.svg'))
              SvgPicture.asset(
                effectiveIndicatorIcon,
                width: indicatorWidth != null ? indicatorWidth!(isError) : 150,
                package: indicatorPackage?.call(isError),
              )
            else
              Image.asset(
                effectiveIndicatorIcon,
                width: indicatorWidth != null ? indicatorWidth!(isError) : 150,
                package: indicatorPackage?.call(isError),
              ),
            const Gap.v(20),
            Text(text),
          ],
          Gap.v(Screens.height / 6),
        ],
      ),
    );
    if (isSliver) {
      if (shouldIndicatorFillRemaining) {
        child = SliverFillRemaining(child: child);
      } else {
        child = SliverToBoxAdapter(child: child);
      }
    }
    return DefaultTextStyle(
      style: textStyle ??
          Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontSize: 17, height: 1.4),
      textAlign: TextAlign.center,
      child: child,
    );
  }
}
