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

class _ArticlesPageState extends State<ArticlesPage> {
  late final LoadingBase<FeedModel> _lb = LoadingBase(
    request: (_, String? lastId) => RecommendAPI.getAllFeedArticles(
      lastId: lastId,
    ),
  );

  Widget itemBuilder(final FeedModel model) {
    final Object feed = model.itemInfo;
    if (feed is ArticleItemModel) {
      return _ArticleWidget(feed, key: ValueKey<String>(feed.articleId));
    }
    if (feed is AdvertiseItemModel) {
      return _AdvertiseWidget(feed, key: ValueKey<String>(feed.advertId));
    }
    return Text(
      feed.toString(),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }

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
              itemBuilder: itemBuilder,
              dividerBuilder: (_, __) => const Gap.v(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleWidget extends StatelessWidget {
  const _ArticleWidget(this.article, {Key? key}) : super(key: key);

  final ArticleItemModel article;

  Widget _buildTitle(BuildContext context) {
    return Text(
      article.articleInfo.title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfo(BuildContext context) {
    return DefaultTextStyle.merge(
      style: context.textTheme.caption,
      child: Row(
        children: <Widget>[
          Text(article.authorUserInfo.userName),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Gap.h(
              1,
              height: 14,
              color: context.theme.dividerColor,
            ),
          ),
          Expanded(
            child: Text(article.articleInfo.createTimeString(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildBrief(BuildContext context) {
    return Text(
      article.articleInfo.briefContent,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: RadiusConstants.r2,
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
            const Gap.h(10),
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
        borderRadius: RadiusConstants.r2,
        color: context.theme.dividerColor.withOpacity(.05),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfo(context),
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
        arguments: Routes.articleDetailPage.d(article.articleId),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
          Text(ad.itemUserInfo.userName),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
