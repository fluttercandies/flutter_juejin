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

class _PostItemWidget extends StatelessWidget {
  const _PostItemWidget(this.post, {Key? key}) : super(key: key);

  final PostItemModel post;

  UserInfoModel get user => post.authorUserInfo;

  PostInfo get postInfo => post.msgInfo;

  HotComment? get hotComment => post.hotComment;

  PostTopic? get topic => post.topic;

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
          Text(
            DateTime.now()
                .difference(postInfo.createTime)
                .differenceString(context.l10n),
          ),
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
      postInfo.content,
      maxLines: 3,
      overflowWidget: TextOverflowWidget(
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(text: '... '),
              TextSpan(
                text: context.l10n.unfold,
                style: const TextStyle(color: themeColorLight),
              ),
            ],
          ),
          style: const TextStyle(height: 1.2),
        ),
      ),
      specialTextSpanBuilder: JJRegExpSpecialTextSpanBuilder(),
    );
  }

  Widget _buildHotComment(BuildContext context) {
    final HotComment comment = hotComment!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.r2,
        color: context.theme.dividerColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(R.ASSETS_ICON_POST_HOT_COMMENT_PNG, height: 20),
              Text(
                context.l10n.numLikes.replaceFirst(
                  '{num}',
                  '${comment.commentInfo.diggCount}',
                ),
                style: context.textTheme.caption,
              ),
            ],
          ),
          Text(comment.commentInfo.commentContent),
        ],
      ),
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

  Widget _buildPraisedUsers(BuildContext context) {
    const double size = 22, offset = 4;
    final List<UserInfoModel> users = post.diggUser;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: (size - offset) * users.length + offset,
          height: size,
          child: Stack(
            children: List<Widget>.generate(
              users.length,
              (int index) => PositionedDirectional(
                top: 0,
                bottom: 0,
                start: index * (size - offset),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.theme.cardColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: users[index].buildCircleAvatar(),
                ),
              ),
            ),
          ),
        ),
        const Gap.h(4),
        Text(context.l10n.liked, style: context.textTheme.caption),
      ],
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
          if (hotComment != null) ...<Widget>[
            _buildHotComment(context),
            const Gap.v(10),
          ],
          Row(
            children: <Widget>[
              if (topic != null) _buildTopic(context),
              if (post.diggUser.isNotEmpty) ...<Widget>[
                const Spacer(),
                _buildPraisedUsers(context),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
