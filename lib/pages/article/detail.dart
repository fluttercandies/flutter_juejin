// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../components/comments.dart';

const _bottomBarHeight = kBottomNavigationBarHeight;

@FFRoute(name: 'article-detail-page')
class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage(this.id, {Key? key, this.item}) : super(key: key);

  final String id;
  final ArticleItemModel? item;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ValueNotifier<bool> _authorInTitle = ValueNotifier<bool>(false);

  String get articleId => widget.id;

  ArticleItemModel get detail => _detail!;
  ArticleItemModel? _detail;

  ArticleInfo get articleInfo => detail.articleInfo;

  UserInfoModel get userInfo => detail.authorUserInfo;

  NestedWebViewController? _controller;
  bool _hasContentLoaded = false;

  @override
  void initState() {
    super.initState();
    _detail = widget.item;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDetail();
    });
  }

  Future<void> _fetchDetail() async {
    final Brightness brightness = overlayContext.brightness;
    return tryCatchResponse(
      request: ContentAPI.getDetailById(articleId),
      onSuccess: (ResponseModel<ArticleItemModel> res) => safeSetState(() {
        _detail = res.data;
        final String url = '${articleInfo.content}'
            '?mode=${brightness.isDark ? 'dark' : 'light'}';
        LogUtil.d(
          'Loading $url for article $articleId...',
          tag: '📃 Article WebView',
        );
        _controller = NestedWebViewController(
          url,
          onLoadComplete: () => Future.delayed(
            const Duration(milliseconds: 150),
            () => safeSetState(() => _hasContentLoaded = true),
          ),
        );
      }),
      reportType: (_) => 'fetch article $articleId detail',
    );
  }

  Widget _buildAuthorInTitle(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ValueListenableBuilder<bool>(
        valueListenable: _authorInTitle,
        builder: (_, bool value, __) => AnimatedSlide(
          offset: value ? Offset.zero : const Offset(0, 1.5),
          curve: Curves.easeInOutCubic,
          duration: kThemeAnimationDuration,
          child: Row(
            children: <Widget>[
              userInfo.buildCircleAvatar(),
              const Gap.h(8),
              Expanded(
                child: Text(
                  userInfo.userName,
                  style: context.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: RadiusConstants.r4,
                  color: context.theme.dividerColor.withOpacity(.05),
                ),
                child: Text(
                  detail.userInteract.followText(context),
                  style: context.textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorInHeader(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          userInfo.buildCircleAvatar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userInfo.buildNameAndLevel(),
                  Text(
                    '${articleInfo.createTimeString(context)} · '
                    '${context.l10n.articleViews(articleInfo.viewCount)}',
                    style: context.textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
          Text(detail.userInteract.followText(context)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return AnimatedPositioned(
      bottom: _hasContentLoaded
          ? 0
          : -_bottomBarHeight - context.mediaQuery.viewPadding.bottom,
      left: 0,
      right: 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: _bottomBarHeight + context.mediaQuery.viewPadding.bottom,
        alignment: Alignment.center,
        color: context.surfaceColor,
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: _IconAction(
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  semanticsLabel: context.l10n.actionLike,
                  label: Text(
                    articleInfo.diggCount == 0
                        ? context.l10n.actionLike
                        : '${articleInfo.diggCount}',
                  ),
                ),
              ),
              Expanded(
                child: _IconAction(
                  icon: const Icon(Icons.message_outlined),
                  semanticsLabel: context.l10n.actionComment,
                  label: Text(
                    articleInfo.commentCount == 0
                        ? context.l10n.actionComment
                        : '${articleInfo.commentCount}',
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentsWidget(
                        detail.articleId,
                        type: FeedItemType.article,
                        count: articleInfo.commentCount,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _IconAction(
                  icon: const Icon(Icons.star_outline),
                  semanticsLabel: context.l10n.actionCollect,
                  label: Text(
                    articleInfo.collectCount == 0
                        ? context.l10n.actionCollect
                        : '${articleInfo.collectCount}',
                  ),
                ),
              ),
              Expanded(
                child: _IconAction(
                  icon: const Icon(Icons.share),
                  label: Text(context.l10n.actionShare),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(top: 16),
            child: Text(
              articleInfo.title,
              style: context.textTheme.headline5,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: VisibilityDetector(
            key: ValueKey<String>('article-$articleId-author'),
            onVisibilityChanged: (VisibilityInfo info) {
              _authorInTitle.value = info.visibleFraction < 0.2;
            },
            child: _buildAuthorInHeader(context),
          ),
        ),
        if (articleInfo.coverImage.isNotEmpty)
          SliverToBoxAdapter(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: articleInfo.slicedCoverImage(
                width: context.mediaQuery.size.width.toPx(),
                extension: 'image',
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
        if (!_hasContentLoaded)
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              color: context.theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: const CupertinoActivityIndicator(),
            ),
          ),
        if (_controller != null)
          ValueListenableBuilder<double>(
            valueListenable: _controller!.scrollHeightNotifier,
            builder:
                (BuildContext context, double scrollHeight, Widget? child) {
              return SliverToNestedScrollBoxAdapter(
                onScrollOffsetChanged: (double scrollOffset) {
                  double y = scrollOffset;
                  if (Platform.isAndroid) {
                    // https://github.com/flutter/flutter/issues/75841
                    y *= ui.window.devicePixelRatio;
                  }
                  _controller!.controller?.scrollTo(x: 0, y: y.ceil());
                },
                childExtent: scrollHeight,
                child: child,
              );
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _hasContentLoaded ? 1 : 0,
              child: JJWebView(
                controller: _controller,
                isWebViewOnly: true,
                enableProgressBar: false,
              ),
            ),
          ),
        SliverGap.v(_bottomBarHeight + context.mediaQuery.viewPadding.bottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: _detail != null ? _buildAuthorInTitle(context) : null,
        titleSpacing: 8,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (_detail != null)
            _buildBody(context)
          else
            Container(
              alignment: Alignment.center,
              color: context.theme.scaffoldBackgroundColor,
              child: CircularProgressIndicator(
                color: context.theme.primaryColor,
              ),
            ),
          _buildBottomBar(context),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    Key? key,
    required this.icon,
    required this.label,
    this.semanticsLabel,
    this.onTap,
  }) : super(key: key);

  final Widget icon;
  final Text label;
  final String? semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Semantics(
          label: semanticsLabel ?? label.data,
          button: true,
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const Gap.h(4),
                label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
