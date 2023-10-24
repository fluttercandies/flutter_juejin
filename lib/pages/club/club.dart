// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

import '../components/comments.dart';

const _pinContentMaxLines = 3;
const double _topicTopPadding = kToolbarHeight + 26;

@FFRoute(name: 'club-page')
class ClubPage extends StatefulWidget {
  const ClubPage(this.id, {super.key, this.topic});

  final String id;
  final PinTopic? topic;

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final GlobalKey _topicInfoKey = GlobalKey();

  double _topicInfoScrollOffset = 0;

  SortType _sortType = SortType.recommend;

  late final LoadingBase<PinItemModel> _lb = LoadingBase(
    request: (_, String? lastId) => RecommendAPI.getRecommendClub(
      widget.id,
      lastId: lastId,
      sortType: _sortType,
    ),
  );

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        double infoHeight = _topicInfoKey.currentContext?.size?.height ?? 1.0;
        double currentScrollPixel = scrollController.position.pixels;

        safeSetState(
          () => _topicInfoScrollOffset =
              currentScrollPixel / (infoHeight - _topicTopPadding) > 1.0
                  ? 1.0
                  : currentScrollPixel / (infoHeight - _topicTopPadding),
        );
      });
    });
  }

  Widget _buildTopicAppBar(BuildContext context, {Widget? title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: headlineTextColorDark,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          if (title != null) title,
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              size: 14,
              color: headlineTextColorDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTopicTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 6.0),
          width: 70,
          height: 70,
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: RadiusConstants.r6,
                child: Image.network(
                  widget.topic!.icon,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.topic!.title,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: headlineTextColorDark,
                ),
              ),
              const Gap.v(6.0),
              Text(
                '沸点${widget.topic!.msgCount} · 掘友${widget.topic!.followerCount}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: headlineTextColorDark,
                ),
              ),
            ],
          ),
        ),
        Tapper(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              borderRadius: RadiusConstants.max,
              color: context.theme.primaryColor,
            ),
            child: Text(
              context.l10n.join,
              style: context.textTheme.bodyMedium?.copyWith(
                color: headlineTextColorDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // PIN TITLE
          _buildTopicTitle(context),
          const Gap.v(6.0),
          // PIN DESCRIPTION (bodySmall)
          Text(
            widget.topic!.description,
            style: context.textTheme.bodySmall?.copyWith(
              color: headlineTextColorDark,
            ),
          ),
          const Gap.v(6.0),
          // MORE INFO (bodySmall)
          Text(
            '更多详细信息 >',
            style: context.textTheme.bodySmall?.copyWith(
              color: headlineTextColorDark,
            ),
          ),
          const Gap.v(6.0),
        ],
      ),
    );
  }

  Widget _buildTopicItem(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        key: _topicInfoKey,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(R.PIN_DETAIL_HEAD_BG_WEBP),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildTopicAppBar(context),
            const Gap.v(5.0),
            _buildTopicBody(context),
            const Gap.v(5.0),
          ],
        ),
      ),
    );
  }

  Widget _buildPinSelectedSwitch(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.r20,
        color: Colors.grey[200],
      ),
      child: Stack(
        alignment: _sortType == SortType.recommend
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.centerEnd,
        children: [
          Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => safeSetState(() {
                    _sortType = SortType.recommend;
                    _lb.refresh(true);
                  }),
                  child: Text(
                    context.l10n.recommend,
                    style: context.textTheme.bodySmall,
                  ),
                ),
                GestureDetector(
                  onTap: () => safeSetState(() {
                    _sortType = SortType.topicLatest;
                    _lb.refresh(true);
                  }),
                  child: Text(
                    context.l10n.latest,
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: _sortType == SortType.recommend ? 35 : 45,
            height: 20,
            decoration: const BoxDecoration(
              borderRadius: RadiusConstants.r10,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                _sortType == SortType.recommend
                    ? context.l10n.recommend
                    : context.l10n.latest,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.textTheme.headlineMedium?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: context.theme.cardColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              context.l10n.arrangement,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.textTheme.headlineSmall?.color,
              ),
            ),
          ),
          _buildPinSelectedSwitch(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background.withOpacity(
          _topicInfoScrollOffset,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 14,
            color: headlineTextColorLight.withOpacity(_topicInfoScrollOffset),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _topicInfoScrollOffset == 0.0 ? 0 : 1,
          child: Text(
            widget.topic?.title ?? '',
            style: context.textTheme.titleSmall?.copyWith(
              color: headlineTextColorLight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              size: 20,
              color: headlineTextColorLight.withOpacity(_topicInfoScrollOffset),
            ),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        bottom: _topicInfoScrollOffset == 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40.0),
                child: _buildPinBar(context),
              )
            : null,
      ),
      body: RefreshListWrapper(
        loadingBase: _lb,
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (PinItemModel model) => _PinItemWidget(
          model,
          key: ValueKey<String>(model.msgId),
        ),
        sliversBuilder: (
          BuildContext context,
          Widget refreshHeader,
          Widget loadingList,
        ) =>
            <Widget>[
          _buildTopicItem(context),
          SliverToBoxAdapter(child: _buildPinBar(context)),
          refreshHeader,
          loadingList,
        ],
        dividerBuilder: (_, __) => const Gap.v(8),
      ),
    );
  }
}

class _PinItemWidget extends StatelessWidget {
  const _PinItemWidget(this.pin, {super.key});

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
      style: context.textTheme.bodySmall,
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
                    if (user.userGrowthInfo != null &&
                        user.userGrowthInfo!.vipLevel > 0)
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
                  style: context.textTheme.bodySmall,
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
    return Tapper(
      onTap: () => context.navigator.pushNamed(
        Routes.clubPage.name,
        arguments: Routes.clubPage.d(topic!.topicId, topic: topic),
      ),
      child: Container(
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
        Text(context.l10n.pinLiked, style: context.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildInteractions(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.bodySmall,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: context.textTheme.bodySmall?.color,
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
            builder: (context) => CommentsWidget(
              pin.msgId,
              count: pinInfo.commentCount,
              type: FeedItemType.pin,
            ),
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
      color: context.theme.cardColor,
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
  const _PinContentWidget(this.content, {super.key});

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
