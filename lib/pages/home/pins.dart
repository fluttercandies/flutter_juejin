// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

import '../pin/comments.dart';

const _pinContentMaxLines = 3;

class PinsPage extends StatefulWidget {
  const PinsPage({Key? key}) : super(key: key);

  @override
  State<PinsPage> createState() => _PinsPageState();
}

class _PinsPageState extends State<PinsPage> {
  late final LoadingBase<PinItemModel> _lb = LoadingBase(
    request: (_, String? lastId) => RecommendAPI.getRecommendPins(
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
            child: JJLogo(),
          ),
          Expanded(
            child: RefreshListWrapper(
              loadingBase: _lb,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (PinItemModel model) => _PinItemWidget(
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

class _PinItemWidget extends StatelessWidget {
  const _PinItemWidget(this.pin, {Key? key}) : super(key: key);

  final PinItemModel pin;

  UserInfoModel get user => pin.authorUserInfo;

  PinInfo get pinInfo => pin.msgInfo;

  HotComment? get hotComment => pin.hotComment;

  PinTopic? get topic => pin.topic;

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
          Text(pinInfo.createTimeString(context)),
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
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      user.userName,
                      style: TextStyle(
                        color: context.textTheme.headlineSmall?.color,
                      ),
                    ),
                    if (user.userGrowthInfo.vipLevel > 0)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 4),
                        child: user.buildVipImage(size: 16),
                      ),
                  ],
                ),
                _buildInfo(context),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildImages(BuildContext context) {
    return Wrap(
      children: pinInfo.picList
          .map(
            (String p) => FractionallySizedBox(
              widthFactor: 1 / 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: RadiusConstants.r6,
                    child: Image.network(p, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHotComment(BuildContext context) {
    final HotComment comment = hotComment!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.r4,
        color: context.theme.canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(R.ASSETS_ICON_POST_HOT_COMMENT_PNG, height: 20),
              if (comment.commentInfo.diggCount > 0)
                Text(
                  context.l10n.pinHotCommentLikes(
                    comment.commentInfo.diggCount,
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
    final List<UserInfoModel> users = pin.diggUser;
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
        Text(context.l10n.pinLiked, style: context.textTheme.caption),
      ],
    );
  }

  Widget _buildInteractions(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: context.textTheme.caption?.color,
          size: 14,
        ),
        child: Row(
          children: <Widget>[
            Expanded(child: _buildDigg(context)),
            Expanded(child: _buildComment(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDigg(BuildContext context) {
    final int count = pinInfo.diggCount;
    return Center(
      child: GestureDetector(
        onTap: () {
          showToast('Not supported yet');
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.thumb_up_alt_outlined),
              const Gap.h(4),
              Text(count == 0 ? context.l10n.actionLike : '$count'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context) {
    final int count = pinInfo.commentCount;
    return Center(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                CommentsWidget(pin.msgId, count: pinInfo.commentCount),
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.message_outlined),
              const Gap.h(4),
              Text(count == 0 ? context.l10n.actionComment : '$count'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.r10,
        color: context.theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUser(context),
          const Gap.v(10),
          _PinContentWidget(pinInfo.content),
          const Gap.v(10),
          if (pinInfo.picList.isNotEmpty) ...[
            _buildImages(context),
            const Gap.v(10),
          ],
          if (hotComment != null) ...<Widget>[
            _buildHotComment(context),
            const Gap.v(10),
          ],
          Row(
            children: <Widget>[
              if (topic != null) _buildTopic(context),
              if (pin.diggUser.isNotEmpty) ...<Widget>[
                const Spacer(),
                _buildPraisedUsers(context),
              ],
            ],
          ),
          const Gap.v(10),
          _buildInteractions(context),
        ],
      ),
    );
  }
}

/// Pins content widget to fold or expand the content
class _PinContentWidget extends StatefulWidget {
  const _PinContentWidget(this.content, {Key? key}) : super(key: key);

  final String content;

  @override
  State<_PinContentWidget> createState() => _PinContentWidgetState();
}

class _PinContentWidgetState extends State<_PinContentWidget> {
  bool isExpanding = false;

  void _moreTap() {
    setState(() {
      isExpanding = !isExpanding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExtendedText(
          widget.content,
          style: const TextStyle(height: 1.3),
          maxLines: isExpanding ? null : _pinContentMaxLines,
          onSpecialTextTap: (val) {
            if (val is TopicText) {}
          },
          overflowWidget: TextOverflowWidget(
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: '... '),
                  TextSpan(
                    text: context.l10n.actionMore,
                    style: const TextStyle(color: themeColorLight),
                    recognizer: TapGestureRecognizer()..onTap = _moreTap,
                  ),
                ],
              ),
              style: const TextStyle(height: 1.3),
            ),
          ),
          specialTextSpanBuilder: JJRegExpSpecialTextSpanBuilder(),
        ),
        if (isExpanding)
          GestureDetector(
            onTap: _moreTap,
            child: Semantics(
              button: true,
              label: context.l10n.actionFold,
              child: Text(
                context.l10n.actionFold,
                style: const TextStyle(color: themeColorLight),
              ),
            ),
          ),
      ],
    );
  }
}
