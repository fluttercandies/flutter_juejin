// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';
import 'package:loading_more_list/loading_more_list.dart';

class RefreshListWrapper<T extends DataModel> extends BaseRefreshWrapper<T> {
  const RefreshListWrapper({
    super.key,
    required super.loadingBase,
    required super.itemBuilder,
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
    super.indicatorWidth,
    super.refreshHeaderBuilder,
    super.refreshHeaderTextStyle,
    super.lastChildLayoutType,
    this.dividerBuilder,
    super.physics,
  });

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
      padding: buildEffectivePadding(context),
      lastChildLayoutType: lastChildLayoutType,
    );
  }
}
