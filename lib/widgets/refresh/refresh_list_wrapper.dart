// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../models/data_model.dart';
import '../../models/loading_base.dart';
import 'base_refresh_wrapper.dart';

class RefreshListWrapper<T extends DataModel> extends BaseRefreshWrapper<T> {
  const RefreshListWrapper({
    Key? key,
    required LoadingBase<T> loadingBase,
    required RefreshItemBuilder<T> itemBuilder,
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
    RefreshIndicatorWidthBuilder? indicatorWidth,
    RefreshHeaderBuilder? refreshHeaderBuilder,
    TextStyle? refreshHeaderTextStyle,
    LastChildLayoutType lastChildLayoutType =
        LastChildLayoutType.fullCrossAxisExtent,
    this.dividerBuilder,
    ScrollPhysics? physics,
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
          indicatorWidth: indicatorWidth,
          refreshHeaderBuilder: refreshHeaderBuilder,
          refreshHeaderTextStyle: refreshHeaderTextStyle,
          lastChildLayoutType: lastChildLayoutType,
          physics: physics,
        );

  final IndexedWidgetBuilder? dividerBuilder;

  @override
  SliverListConfig<T> buildConfig(BuildContext context) {
    return SliverListConfig<T>(
      sourceList: loadingBase,
      itemBuilder: (BuildContext c, T model, int index) {
        if (dividerBuilder == null) {
          return itemBuilder(model);
        }
        if (index.isEven) {
          return itemBuilder(loadingBase[index ~/ 2]);
        }
        return dividerBuilder!(c, index);
      },
      indicatorBuilder: effectiveIndicatorBuilder,
      childCountBuilder: dividerBuilder != null
          ? (int length) => length == 0 ? 0 : length * 2 - 1
          : null,
      getActualIndex: dividerBuilder != null ? (int index) => index ~/ 2 : null,
      padding: buildEffectivePadding(context),
      lastChildLayoutType: lastChildLayoutType,
    );
  }
}
