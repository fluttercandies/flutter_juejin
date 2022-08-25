// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with TickerProviderStateMixin {
  final searchTextController = TextEditingController();
  bool searchHasText = false;

  late final toolBarHeight = AnimationController(
    vsync: this,
    upperBound: kToolbarHeight,
    value: kToolbarHeight,
    duration: const Duration(milliseconds: 300),
  );

  /// tabbar trigger the page change
  bool tabTrigger = false;

  int pageIndex = 1;
  late PageController pageController;
  late TabController tabController;
  final tabs = <Widget>[
    const Tab(text: '关注'),
    const Tab(text: '推荐'),
  ];

  final pages = <Widget>[
    const _ArticleTabPage<ArticleItemModel>(isFollow: true),
    const _ArticleTabPage<FeedModel>(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getCates);

    pageController = PageController(initialPage: pageIndex);
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: pageIndex,
    );
    pageController.addListener(_onPageChange);
    tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {}

  void _onPageChange() {
    if (tabTrigger) {
      return;
    }
    final offset = (pageController.page ?? 0) - pageIndex;

    if (offset >= 0.99) {
      pageIndex = (pageController.page ?? 0).round();
      tabController.index = pageIndex;
    } else if (offset <= -0.99) {
      pageIndex = (pageController.page ?? 0).round();
      tabController.index = pageIndex;
    } else {
      tabController.offset = offset;
    }
  }

  Future<void> _getCates(t) async {
    final cates = await TagAPI.getCategories();
    if (cates.isSucceed) {
      for (final cate in cates.models ?? <Category>[]) {
        tabs.add(Tab(text: cate.categoryName));
        pages.add(
          _ArticleTabPage<ArticleItemModel>(
            categoryId: cate.categoryId,
          ),
        );
      }

      tabController.dispose();
      tabController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: pageIndex,
      );
      setState(() {});
    } else {
      LogUtil.e(cates.msg);
    }
  }

  Widget _buildSearch(BuildContext context) {
    final headTextColor = (context.theme.appBarTheme.foregroundColor ??
            context.theme.colorScheme.onSecondary)
        .withAlpha(150);
    return Center(
      child: TextField(
        controller: searchTextController,
        style: context.textTheme.titleSmall?.copyWith(
          color: headTextColor,
        ),
        strutStyle: const StrutStyle(height: 1),
        scrollPadding: EdgeInsets.zero,
        onChanged: (v) {
          if (searchHasText && v.isEmpty) {
            setState(() {
              searchHasText = false;
            });
          } else if (!searchHasText && v.isNotEmpty) {
            setState(() {
              searchHasText = true;
            });
          }
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(
            Icons.search,
            color: headTextColor,
          ),
          suffixIcon: searchHasText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchTextController.clear();
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close,
                    color: headTextColor,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: headTextColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: headTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCatalog(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            isScrollable: true,
            controller: tabController,
            indicatorColor: context.theme.primaryColor,
            onTap: (index) {
              tabTrigger = true;
              pageIndex = index;
              pageController
                  .animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              )
                  .whenComplete(() {
                tabTrigger = false;
              });
            },
            tabs: tabs,
          ),
        ),
        GestureDetector(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.menu, size: 24),
          ),
        ),
      ],
    );
  }

  double? lastPositionPixel;

  /// Notify the search header to show or hide
  bool handleNotify(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    int direction =
        notification.metrics.axisDirection == AxisDirection.down ? 1 : -1;
    double? computedValue;

    if (notification is ScrollStartNotification) {
      lastPositionPixel = notification.metrics.pixels;
    } else if (notification is ScrollUpdateNotification) {
      final scrollPixel = notification.scrollDelta! * direction;

      /// Scroll reached top, only need to show
      if (notification.metrics.extentBefore <= 0) {
        toolBarHeight.animateTo(kToolbarHeight, curve: Curves.easeOut);
        return true;
      }

      /// Scroll reached bottom, only need to hide
      if (notification.metrics.extentAfter <= 0) {
        toolBarHeight.animateTo(0, curve: Curves.easeOut);
        return true;
      }
      if (scrollPixel <= 0 && toolBarHeight.value >= kToolbarHeight) {
        return true;
      }
      if (scrollPixel >= 0 && toolBarHeight.value <= 0) {
        return true;
      }

      // No animate duration scrolling
      toolBarHeight
        ..stop()
        ..animateTo(
          toolBarHeight.value - scrollPixel,
          duration: Duration.zero,
        );
    } else if (notification is OverscrollNotification) {
      if (toolBarHeight.value < kToolbarHeight && notification.overscroll < 0) {
        computedValue =
            (notification.overscroll) * direction < 0 ? kToolbarHeight : 0;
      }
    } else if (notification is ScrollEndNotification) {
      if (toolBarHeight.value > 0 && toolBarHeight.value < kToolbarHeight) {
        final primaryVelocity =
            (notification.dragDetails?.primaryVelocity ?? 0.0) * direction;
        if (primaryVelocity != 0) {
          computedValue = primaryVelocity > 0 ? 0 : kToolbarHeight;
        } else if (lastPositionPixel != null) {
          computedValue =
              (notification.metrics.pixels - lastPositionPixel!) * direction < 0
                  ? kToolbarHeight
                  : 0;
        }
      }
    }
    if (computedValue != null) {
      toolBarHeight.animateTo(computedValue, curve: Curves.easeOut);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          ValueListenableBuilder<double>(
            valueListenable: toolBarHeight,
            builder: (context, value, child) {
              return SizedBox(
                height: value,
                child: child,
              );
            },
            child: SingleChildScrollView(
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    const Gap.h(16),
                    const JJLogo(heroTag: defaultLogoHeroTag),
                    const Gap.h(16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildSearch(context),
                      ),
                    ),
                    const Gap.h(16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    const Gap.h(16),
                  ],
                ),
              ),
            ),
          ),
          buildCatalog(context),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: handleNotify,
              child: PageView(
                controller: pageController,
                children: pages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleTabPage<T extends DataModel> extends StatefulWidget {
  const _ArticleTabPage({
    Key? key,
    this.isFollow = false,
    this.cursorType = CursorType.raw,
    this.categoryId,
  }) : super(key: key);

  final bool isFollow;

  final String? categoryId;

  final CursorType cursorType;

  @override
  State<_ArticleTabPage<T>> createState() => __ArticleTabPageState<T>();
}

class __ArticleTabPageState<T extends DataModel>
    extends State<_ArticleTabPage<T>> with AutomaticKeepAliveClientMixin {
  late final LoadingBase<T> _lb = LoadingBase(
    getCursorType: () => tagId == null ? widget.cursorType : CursorType.raw,
    request: (_, String? lastId) => RecommendAPI.getArticles<T>(
      isFollow: widget.isFollow,
      lastId: lastId,
      categoryId: widget.categoryId,
      tagId: tagId,
    ),
  );

  String? tagId;
  List<Tag>? tags;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback(_loadTags);
    }
  }

  Future<void> _loadTags(t) async {
    final result = await RecommendAPI.getRecommendTags(
      categoryId: widget.categoryId!,
    );
    if (result.isSucceed) {
      setState(() {
        tags = result.models;
      });
    } else {
      LogUtil.e(result.msg);
    }
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tag in tags!)
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if (tagId == tag.tagId) {
                      tagId = null;
                    } else {
                      tagId = tag.tagId;
                    }
                    _lb.refresh(true);
                  });
                },
                style: TextButton.styleFrom(
                  primary: tagId == tag.tagId
                      ? context.theme.primaryColor
                      : context.colorScheme.outline,
                  backgroundColor: context.colorScheme.surface,
                  shape: const StadiumBorder(),
                  visualDensity: VisualDensity.compact,
                  textStyle: context.textTheme.caption,
                ),
                child: Text(tag.tagName),
              ),
            ),
        ],
      ),
    );
  }

  Widget itemBuilder(final T model) {
    if (model is FeedModel) {
      final Object feed = model.itemInfo;
      if (feed is ArticleItemModel) {
        return _ArticleWidget(feed, key: ValueKey<String>(feed.articleId));
      }
      if (feed is AdvertiseItemModel) {
        return _AdvertiseWidget(feed, key: ValueKey<String>(feed.advertId));
      }
    } else if (model is ArticleItemModel) {
      return _ArticleWidget(model, key: ValueKey<String>(model.articleId));
    }
    return Text(
      model.toString(),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        if (widget.categoryId != null && tags != null && tags!.isNotEmpty)
          _buildTags(),
        Expanded(
          child: RefreshListWrapper<T>(
            loadingBase: _lb,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: itemBuilder,
            dividerBuilder: (_, __) => const Gap.v(8),
          ),
        ),
      ],
    );
  }
}

class _ArticleWidget extends StatelessWidget {
  const _ArticleWidget(this.article, {Key? key}) : super(key: key);

  final ArticleItemModel article;

  Widget _buildTitle(BuildContext context) {
    return Text(
      article.articleInfo.title,
      style: context.textTheme.headlineSmall?.copyWith(fontSize: 14),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfo(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: Row(
        children: <Widget>[
          Text(
            article.authorUserInfo.userName,
            style: TextStyle(color: context.textTheme.headlineSmall?.color),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Gap.h(
              1,
              height: 14,
              color: context.theme.dividerColor,
            ),
          ),
          Expanded(
            child: Text(
              article.articleInfo.createTimeString(context),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrief(BuildContext context) {
    return Text(
      article.articleInfo.briefContent,
      style: const TextStyle(fontSize: 13, height: 1.3),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: RadiusConstants.r4,
        child: Image.network(
          article.articleInfo.slicedCoverImage(),
          fit: BoxFit.cover,
        ),
      ),
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
            _buildDigg(context),
            const Gap.h(16),
            _buildComment(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDigg(BuildContext context) {
    final int count = article.articleInfo.diggCount;
    return Row(
      children: <Widget>[
        const Icon(Icons.thumb_up_alt_outlined),
        const Gap.h(4),
        Text(count == 0 ? context.l10n.actionLike : '$count'),
      ],
    );
  }

  Widget _buildComment(BuildContext context) {
    final int count = article.articleInfo.commentCount;
    return Row(
      children: <Widget>[
        const Icon(Icons.message_outlined),
        const Gap.h(4),
        Text(count == 0 ? context.l10n.actionComment : '$count'),
      ],
    );
  }

  Widget _buildCategory(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.r4,
        color: context.theme.canvasColor,
      ),
      child: Text(
        article.category.categoryName,
        style: context.textTheme.caption,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTitle(context),
        const Gap.v(10),
        SizedBox(
          height: 68,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfo(context),
                    const Gap.v(10),
                    _buildBrief(context),
                  ],
                ),
              ),
              if (article.articleInfo.coverImage.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: _buildCoverImage(context),
                ),
            ],
          ),
        ),
        const Gap.v(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildInteractions(context),
            _buildCategory(context),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tapper(
      onTap: () => context.navigator.pushNamed(
        Routes.articleDetailPage.name,
        arguments: Routes.articleDetailPage.d(article.articleId, item: article),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: RadiusConstants.r10,
          color: context.theme.cardColor,
        ),
        child: _buildContent(context),
      ),
    );
  }
}

class _AdvertiseWidget extends StatelessWidget {
  const _AdvertiseWidget(this.ad, {Key? key}) : super(key: key);

  final AdvertiseItemModel ad;

  Widget _buildTitle(BuildContext context) {
    return Text(
      ad.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfo(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: Row(
        children: <Widget>[
          Text(
            ad.itemUserInfo.userName,
            style: TextStyle(
              color: context.textTheme.bodyMedium?.color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Gap.h(
              1,
              height: 14,
              color: context.theme.dividerColor,
            ),
          ),
          Text(ad.createTimeString(context)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: RadiusConstants.r2,
              color: context.theme.dividerColor.withOpacity(.05),
            ),
            child: Text(
              context.l10n.advertiseAbbr,
              style: context.textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrief(BuildContext context) {
    return Text(
      ad.brief,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: RadiusConstants.r2,
        child: Image.network(ad.picture, fit: BoxFit.cover),
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
          _buildInfo(context),
          const Gap.v(10),
          SizedBox(
            height: 68,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle(context),
                      _buildBrief(context),
                    ],
                  ),
                ),
                if (ad.picture.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: _buildCoverImage(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
