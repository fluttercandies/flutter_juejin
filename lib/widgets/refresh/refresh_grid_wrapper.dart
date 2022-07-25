// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../models/data_model.dart';
import '../../models/loading_base.dart';
import 'base_refresh_wrapper.dart';

class RefreshGridWrapper<T extends DataModel> extends BaseRefreshWrapper<T> {
  const RefreshGridWrapper({
    Key? key,
    required LoadingBase<T> loadingBase,
    required RefreshItemBuilder<T> itemBuilder,
    required this.gridDelegate,
    RefreshSliversBuilder? sliversBuilder,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool enableRefresh = true,
    EdgeInsetsGeometry? padding,
    bool shouldIndicatorFillRemaining = true,
    RefreshIndicatorBuilder? indicatorBuilder,
    RefreshPlaceholderBuilder? indicatorPlaceholder,
    RefreshResourceBuilder? indicatorIcon,
    RefreshPackageBuilder? indicatorPackage,
    RefreshResourceBuilder? indicatorText,
    TextStyle? indicatorTextStyle,
    RefreshHeaderBuilder? refreshHeaderBuilder,
    TextStyle? refreshHeaderTextStyle,
  }) : super(
          key: key,
          loadingBase: loadingBase,
          itemBuilder: itemBuilder,
          sliversBuilder: sliversBuilder,
          controller: controller,
          scrollDirection: scrollDirection,
          enableRefresh: enableRefresh,
          padding: padding,
          shouldIndicatorFillRemaining: shouldIndicatorFillRemaining,
          indicatorBuilder: indicatorBuilder,
          indicatorPlaceholder: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          indicatorTextStyle: indicatorTextStyle,
          refreshHeaderBuilder: refreshHeaderBuilder,
          refreshHeaderTextStyle: refreshHeaderTextStyle,
        );

  RefreshGridWrapper.count({
    Key? key,
    required LoadingBase<T> loadingBase,
    required RefreshItemBuilder<T> itemBuilder,
    required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool enableRefresh = true,
    EdgeInsetsGeometry? padding,
    bool shouldIndicatorFillRemaining = true,
    RefreshIndicatorBuilder? indicatorBuilder,
    RefreshPlaceholderBuilder? indicatorPlaceholder,
    RefreshResourceBuilder? indicatorIcon,
    RefreshPackageBuilder? indicatorPackage,
    RefreshResourceBuilder? indicatorText,
    TextStyle? indicatorTextStyle,
    RefreshIndicatorWidthBuilder? indicatorWidth,
    RefreshHeaderBuilder? refreshHeaderBuilder,
    TextStyle? refreshHeaderTextStyle,
    LastChildLayoutType lastChildLayoutType =
        LastChildLayoutType.fullCrossAxisExtent,
  })  : gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        ),
        super(
          key: key,
          loadingBase: loadingBase,
          itemBuilder: itemBuilder,
          controller: controller,
          scrollDirection: scrollDirection,
          enableRefresh: enableRefresh,
          padding: padding,
          shouldIndicatorFillRemaining: shouldIndicatorFillRemaining,
          indicatorBuilder: indicatorBuilder,
          indicatorPlaceholder: indicatorPlaceholder,
          indicatorIcon: indicatorIcon,
          indicatorPackage: indicatorPackage,
          indicatorText: indicatorText,
          indicatorTextStyle: indicatorTextStyle,
          indicatorWidth: indicatorWidth,
          refreshHeaderBuilder: refreshHeaderBuilder,
          refreshHeaderTextStyle: refreshHeaderTextStyle,
          lastChildLayoutType: lastChildLayoutType,
        );

  final SliverGridDelegate gridDelegate;

  @override
  SliverListConfig<T> buildConfig(BuildContext context) {
    return SliverListConfig<T>(
      sourceList: loadingBase,
      padding: buildEffectivePadding(context),
      indicatorBuilder: effectiveIndicatorBuilder,
      gridDelegate: gridDelegate,
      itemBuilder: (_, T model, __) => itemBuilder(model),
      lastChildLayoutType: lastChildLayoutType,
    );
  }
}
