// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  Widget _buildHeaderActions(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            context.brightness.isDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
          const Gap.h(16),
          const Icon(Icons.notifications_none_outlined),
          const Gap.h(16),
          const Icon(Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: context.theme.dividerColor,
      child: SvgPicture.asset(R.ASSETS_BRAND_SVG),
    );
  }

  Widget _buildUsername(BuildContext context) {
    return const Text(
      '登录/注册',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildUser(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
              child: _buildUserAvatar(context),
            ),
          ),
          const Gap.h(16),
          _buildUsername(context),
        ],
      ),
    );
  }

  Widget _buildCounters(BuildContext context) {
    Widget counter(int? value, String name) {
      return Column(
        children: <Widget>[
          Text(
            value?.toString() ?? '0',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(name, style: context.textTheme.caption),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [counter(0, '点赞'), counter(0, '收藏'), counter(0, '关注')],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            _buildHeaderActions(context),
            const Gap.v(28),
            _buildUser(context),
            const Gap.v(20),
            _buildCounters(context),
          ],
        ),
      ),
    );
  }
}
