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
    super.key,
    required super.loadingBase,
    required super.itemBuilder,
    required this.gridDelegate,
    super.sliversBuilder,
    super.controller,
    super.scrollDirection,
    super.enableRefresh,
    super.padding,
    super.shouldIndicatorFillRemaining,
    super.indicatorBuilder,
    super.indicatorPlaceholder,
    super.indicatorIcon,
    super.indicatorPackage,
    super.indicatorText,
    super.indicatorTextStyle,
    super.refreshHeaderBuilder,
    super.refreshHeaderTextStyle,
  });

  RefreshGridWrapper.count({
    super.key,
    required super.loadingBase,
    required super.itemBuilder,
    required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    super.controller,
    super.scrollDirection,
    super.enableRefresh,
    super.padding,
    super.shouldIndicatorFillRemaining,
    super.indicatorBuilder,
    super.indicatorPlaceholder,
    super.indicatorIcon,
    super.indicatorPackage,
    super.indicatorText,
    super.indicatorTextStyle,
    super.indicatorWidth,
    super.refreshHeaderBuilder,
    super.refreshHeaderTextStyle,
    super.lastChildLayoutType,
  })  : gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
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
