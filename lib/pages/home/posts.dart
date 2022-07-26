// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:extended_text/extended_text.dart';
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
              itemBuilder: (PostItemModel model) => _PostItemWidget(
                model,
                key: ValueKey<String>(model.msgId),
              ),
              dividerBuilder: (_, __) => const Gap.v(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostItemWidget extends StatefulWidget {
  const _PostItemWidget(this.post, {Key? key}) : super(key: key);

  final PostItemModel post;

  @override
  State<_PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<_PostItemWidget> {
  bool _isContentCollapsed = true;

  UserInfoModel get user => widget.post.authorUserInfo;

  PostInfo get postInfo => widget.post.msgInfo;

  PostTopic? get topic => widget.post.topic;

  Widget _buildInfo(BuildContext context) {
    final StringBuffer sb = StringBuffer();
    if (user.jobTitle.isNotEmpty) {
      sb.write(user.jobTitle);
      if (user.company.isNotEmpty) {
        sb.write(' @ ');
      }
    }
    if (user.company.isNotEmpty) {
      sb.write(user.company);
    }
    final String info = sb.toString();
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(info, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (info.isNotEmpty) const Text(' · '),
          Text(postInfo.createTime),
        ],
      ),
    );
  }

  Widget _buildUser(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: <Widget>[
          user.buildCircleAvatar(),
          const Gap.h(8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(user.userName), _buildInfo(context)],
            ),
          ),
          const Icon(Icons.more_vert_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ExtendedText(
      widget.post.msgInfo.content,
      maxLines: _isContentCollapsed ? 3 : null,
      overflowWidget: const TextOverflowWidget(
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(text: '... '),
              const TextSpan(
                text: '展开',
                style: TextStyle(color: themeColorLight),
              ),
            ],
          ),
          style: const TextStyle(height: 1.2),
        ),
      ),
      specialTextSpanBuilder: JJRegExpSpecialTextSpanBuilder(),
    );
  }

  Widget _buildTopic(BuildContext context) {
    final Color themeColor = Color.lerp(themeColorLight, Colors.white, .2)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.max,
        color: themeColorLight.withOpacity(.2),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.ac_unit_rounded, color: themeColor, size: 14),
          const Gap.h(4),
          Text(
            topic!.title,
            style: TextStyle(color: themeColor, fontSize: 11),
          ),
          Icon(Icons.chevron_right, color: themeColor, size: 14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: context.theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUser(context),
          const Gap.v(10),
          _buildContent(context),
          const Gap.v(10),
          Row(
            children: <Widget>[
              if (topic != null) _buildTopic(context),
            ],
          ),
        ],
      ),
    );
  }
}
