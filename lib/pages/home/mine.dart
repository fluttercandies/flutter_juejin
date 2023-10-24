// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juejin/exports.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  Widget _buildHeaderActions(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      child: IconTheme.merge(
        data: IconThemeData(color: context.textTheme.bodyMedium?.color),
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
      ),
    );
  }

  Widget _buildUser(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final userModel = ref.watch(userProvider);
        return GestureDetector(
          onTap: () => context.navigator.pushNamed(
            userModel.isLogin ? Routes.userProfile.name : Routes.loginPage.name,
          ),
          child: SizedBox(
            height: 54,
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child: userModel.isLogin
                        ? Image.network(
                            userModel.avatarUrl,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            padding: const EdgeInsets.all(8),
                            color: context.theme.dividerColor,
                            child: SvgPicture.asset(R.ASSETS_BRAND_SVG),
                          ),
                  ),
                ),
                const Gap.h(16),
                Text(
                  userModel.isLogin
                      ? userModel.screenName
                      : context.l10n.userSignInOrUp,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          Text(name, style: context.textTheme.bodySmall),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          counter(0, context.l10n.userLikes),
          counter(0, context.l10n.userFavorites),
          counter(0, context.l10n.userFollows),
        ],
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
