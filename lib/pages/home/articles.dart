// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';

/// from tabs.dart
const double _kTabHeight = 46.0;

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with TickerProviderStateMixin {
  final searchTextController = TextEditingController();
  bool searchHasText = false;

  int currentTabIndex = 1;
  late TabController tabController = TabController(
    length: tabs.length,
    initialIndex: currentTabIndex,
    vsync: this,
  )..addListener(_onTabBarChange);

  final scrollController = ScrollController();

  bool? isCategoryLoadError = false;
  List<Category>? categories;
  final tabs = <Widget>[];

  /// Notice subpage to refresh
  final refreshSubscribe = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getCategories);
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (tabs.isEmpty) {
      tabs.add(
        Tab(
          text: context.l10n.categoryTabFollowing,
          key: const PageStorageKey('following'),
        ),
      );
      tabs.add(
        Tab(
          text: context.l10n.categoryTabRecommend,
          key: const PageStorageKey('recommend'),
        ),
      );
    }
  }

  Future<void> _getCategories(t) async {
    if (isCategoryLoadError == true) {
      setState(() {
        isCategoryLoadError = null;
      });
    }
    final categoryList = await TagAPI.getCategoryBriefs();
    if (!mounted) return;

    if (categoryList.isSucceed) {
      for (final category in categoryList.models ?? <Category>[]) {
        tabs.add(
          Tab(
            key: PageStorageKey('category-${category.categoryId}'),
            text: category.categoryName,
          ),
        );
      }
      tabController.removeListener(_onTabBarChange);
      tabController.dispose();

      tabController = TabController(
        length: tabs.length,
        initialIndex: currentTabIndex,
        vsync: this,
      )..addListener(_onTabBarChange);

      safeSetState(() {
        isCategoryLoadError = false;
        categories = categoryList.models;
      });
    } else {
      setState(() {
        isCategoryLoadError = true;
      });
      LogUtil.e(categoryList.msg);
    }
  }

  void _onTabBarChange() {
    if (tabController.indexIsChanging) return;
    if (currentTabIndex == tabController.index) return;
    setState(() {
      currentTabIndex = tabController.index;
    });
  }

  void _onTabBarTap(int index) {
    if (index == currentTabIndex) {
      if (scrollController.offset <= 0) {
        refreshSubscribe.add((tabs[index].key as PageStorageKey).value);
      } else {
        scrollController.animateTo(
          -20,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
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

  Widget _buildCatalog(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _kTabHeight,
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: context.theme.primaryColor,
            padding: const EdgeInsets.only(right: 48),
            onTap: _onTabBarTap,
            tabs: tabs.toList(),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isCategoryLoadError == true
                ? () => _getCategories(0)
                : null, // TODO(shirne) edit and sort cates
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.background.withAlpha(0),
                    context.colorScheme.background,
                    context.colorScheme.background,
                  ],
                  stops: const [0, 0.42, 1],
                ),
              ),
              child: isCategoryLoadError == true
                  ? const Icon(Icons.replay_outlined, size: 24)
                  : const Icon(Icons.menu, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                backgroundColor: context.colorScheme.background,
                expandedHeight: kToolbarHeight + _kTabHeight,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildCatalog(context),
                  titlePadding: EdgeInsets.zero,
                  expandedTitleScale: 1,
                  background: Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          const Gap.h(16),
                          const JJLogo(heroTag: defaultLogoHeroTag),
                          const Gap.h(16),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            _ArticleTabPage<ArticleItemModel>(
              key: tabs[0].key,
              isFollow: true,
              hasSort: false,
              isActive: currentTabIndex == 0,
              refreshStream: refreshSubscribe.stream,
            ),
            _ArticleTabPage<FeedModel>(
              key: tabs[1].key,
              isActive: currentTabIndex == 1,
              refreshStream: refreshSubscribe.stream,
            ),
            if (categories != null)
              for (int i = 0; i < (categories?.length ?? 0); i++)
                _ArticleTabPage<ArticleItemModel>(
                  key: PageStorageKey('category-${categories![i].categoryId}'),
                  categoryId: categories![i].categoryId,
                  isActive: currentTabIndex == i + 2,
                  refreshStream: refreshSubscribe.stream,
                ),
          ],
        ),
      ),
    );
  }
}

class _ArticleTabPage<T extends DataModel> extends StatefulWidget {
  const _ArticleTabPage({
    super.key,
    this.isFollow = false,
    this.cursorType = CursorType.raw,
    this.categoryId,
    this.hasSort = true,
    this.isActive = false,
    this.refreshStream,
  });

  final bool isFollow;

  final String? categoryId;

  final CursorType cursorType;

  final bool hasSort;

  final bool isActive;

  final Stream<String>? refreshStream;

  @override
  State<_ArticleTabPage<T>> createState() => _ArticleTabPageState<T>();
}

class _ArticleTabPageState<T extends DataModel>
    extends State<_ArticleTabPage<T>>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late final LoadingBase<T> _lb = LoadingBase(
    getCursorType: () => tagId == null ? widget.cursorType : CursorType.raw,
    request: (_, String? lastId) => RecommendAPI.getArticles<T>(
      isFollow: widget.isFollow,
      lastId: lastId,
      categoryId: widget.categoryId,
      tagId: tagId,
      sortType: sortType,
    ),
  );

  SortType sortType = SortType.recommend;

  String? tagId;

  @override
  bool get wantKeepAlive => true;

  /// use for hiden
  final controller = ScrollController(keepScrollOffset: false);

  @override
  void initState() {
    super.initState();
    widget.refreshStream?.listen(_onRefreshNotify);
  }

  @override
  void dispose() {
    _lb.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onRefreshNotify(String event) {
    if (event == (widget.key as PageStorageKey).value) {
      _lb.refresh(true);
    }
  }

  Widget _buildSort(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: RadiusConstants.r10,
        ),
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  sortType = SortType.recommend;
                });
                _lb.refresh(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: sortType == SortType.recommend
                    ? context.theme.primaryColor
                    : context.theme.hintColor,
                shape: const StadiumBorder(),
                visualDensity: VisualDensity.compact,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              child: Text(context.l10n.sortRecommend),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  sortType = SortType.latest;
                });
                _lb.refresh(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: sortType == SortType.latest
                    ? context.theme.primaryColor
                    : context.theme.hintColor,
                shape: const StadiumBorder(),
                visualDensity: VisualDensity.compact,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              child: Text(context.l10n.sortLatest),
            ),
          ],
        ),
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
        if (widget.categoryId != null)
          Padding(
            padding: const EdgeInsets.only(
              top: kToolbarHeight,
            ),
            child: _ArticleTagRow(
              categoryId: widget.categoryId!,
              onTagChanged: (String? newTag) {
                tagId = newTag;
                _lb.refresh(true);
              },
            ),
          ),
        Expanded(
          child: RefreshListWrapper<T>(
            loadingBase: _lb,
            physics:
                widget.isActive ? null : const NeverScrollableScrollPhysics(),
            controller: widget.isActive ? null : ScrollController(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliversBuilder: (context, refreshHeader, loadingList) => <Widget>[
              if (widget.categoryId == null)
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                ),
              if (!widget.isFollow) _buildSort(context),
              refreshHeader,
              loadingList,
            ],
            itemBuilder: itemBuilder,
            dividerBuilder: (_, __) => const Gap.v(8),
          ),
        ),
      ],
    );
  }
}

class _ArticleTagRow extends StatefulWidget {
  const _ArticleTagRow({
    super.key,
    required this.categoryId,
    this.onTagChanged,
  });

  final String categoryId;

  final void Function(String?)? onTagChanged;

  @override
  State<_ArticleTagRow> createState() => _ArticleTagRowState();
}

class _ArticleTagRowState extends State<_ArticleTagRow> {
  String? tagId;
  List<Tag>? tagList;

  bool get hasTags => tagList != null && tagList!.isNotEmpty;

  final tagRowKey = GlobalKey();
  final tagScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_loadTags);
  }

  @override
  void dispose() {
    tagScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTags(_) async {
    final result = await RecommendAPI.getRecommendTags(
      categoryId: widget.categoryId,
    );

    if (result.isSucceed) {
      safeSetState(() {
        tagList = result.models;
      });
    } else {
      LogUtil.e(result.msg);
    }
  }

  void _ensureTagShow() {
    tagRowKey.currentContext?.visitChildElements((element) {
      final widget = element.widget;
      if (widget is _ArticleTag && element.renderObject != null) {
        if (widget.tagId == tagId) {
          tagScrollController.position.ensureVisible(
            element.renderObject!,
            alignment: 0.5,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  Widget _buildTagDropDown(BuildContext context, OverlayEntry entry) {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      color: context.colorScheme.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              children: [
                _ArticleTag(
                  tagId: null,
                  tagName: context.l10n.tagAll,
                  isActive: tagId == null,
                  onTap: () {
                    entry.remove();
                    if (tagId == null) {
                      return;
                    }
                    setState(() {
                      tagId = null;
                    });
                    tagScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeIn,
                    );
                    widget.onTagChanged?.call(tagId);
                  },
                ),
                for (final tag in tagList!)
                  _ArticleTag(
                    tagId: tag.tagId,
                    tagName: tag.tagName,
                    isActive: tagId == tag.tagId,
                    onTap: () {
                      entry.remove();
                      setState(() {
                        if (tagId == tag.tagId) {
                          tagId = null;
                        } else {
                          tagId = tag.tagId;
                        }
                      });
                      _ensureTagShow();
                      widget.onTagChanged?.call(tagId);
                    },
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              entry.remove();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.keyboard_arrow_up_outlined, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: tagScrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 8, right: 48),
          child: Row(
            key: tagRowKey,
            children: [
              _ArticleTag(
                tagId: null,
                tagName: context.l10n.tagAll,
                isActive: tagId == null,
                onTap: () {
                  if (tagId == null) {
                    return;
                  }
                  setState(() {
                    tagId = null;
                  });
                  widget.onTagChanged?.call(tagId);
                },
              ),
              for (final tag in tagList ?? [])
                _ArticleTag(
                  tagId: tag.tagId,
                  tagName: tag.tagName,
                  isActive: tagId == tag.tagId,
                  onTap: () {
                    setState(() {
                      if (tagId == tag.tagId) {
                        tagId = null;
                      } else {
                        tagId = tag.tagId;
                      }
                      widget.onTagChanged?.call(tagId);
                    });
                  },
                ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTapUp: (details) {
              Feedback.forTap(context);
              showDropDown(
                context: context,
                offset: details.globalPosition.dy - details.localPosition.dy,
                builder: _buildTagDropDown,
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.background.withAlpha(0),
                    context.colorScheme.background,
                    context.colorScheme.background,
                  ],
                  stops: const [0, 0.42, 1],
                ),
              ),
              child: const Icon(Icons.keyboard_arrow_down_outlined, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleTag extends StatelessWidget {
  const _ArticleTag({
    super.key,
    required this.tagId,
    required this.tagName,
    this.isActive = false,
    this.onTap,
  });

  final bool isActive;

  final VoidCallback? onTap;

  final String? tagId;
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: isActive
              ? context.theme.primaryColor
              : context.colorScheme.outline,
          backgroundColor: context.colorScheme.surface,
          shape: const StadiumBorder(),
          visualDensity: VisualDensity.compact,
          textStyle: context.textTheme.bodySmall,
        ),
        child: Text(tagName),
      ),
    );
  }
}

class _ArticleWidget extends StatelessWidget {
  const _ArticleWidget(this.article, {super.key});

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
      style: context.textTheme.bodySmall,
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
      style: context.textTheme.bodySmall,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          color: context.textTheme.bodySmall?.color,
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
        style: context.textTheme.bodySmall,
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
  const _AdvertiseWidget(this.ad, {super.key});

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
      style: context.textTheme.bodySmall,
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
              style: context.textTheme.bodySmall,
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

OverlayEntry showDropDown({
  required BuildContext context,
  required Widget Function(BuildContext, OverlayEntry) builder,
  double offset = 0,
  Color barrierColor = const Color(0x80000000),
  bool barrierDismissible = true,
}) {
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          if (barrierDismissible) {
            overlayEntry.remove();
          }
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(top: offset),
          child: Container(
            color: barrierColor,
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                // void to prevent barrier dismiss
              },
              child: builder(context, overlayEntry),
            ),
          ),
        ),
      );
    },
  );
  Overlay.of(context).insert(overlayEntry);
  return overlayEntry;
}
