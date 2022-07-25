// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final LoadingBase<PostItemModel> _lb = LoadingBase(
    request: (_, String? lastId) => RecommendAPI.getRecommendPosts(
      lastId: lastId,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: JJLogo(heroTag: defaultLogoHeroTag),
          ),
          Expanded(
            child: RefreshListWrapper(
              loadingBase: _lb,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (PostItemModel model) => Text(model.msgInfo.content),
              dividerBuilder: (_, __) => const Gap.v(8),
            ),
          ),
        ],
      ),
    );
  }
}
