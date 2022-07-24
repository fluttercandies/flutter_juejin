// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:juejin/exports.dart';

@FFRoute(name: 'article-detail-page')
class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  final ArticleItemModel article;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String get articleId => widget.article.articleId;

  ArticleItemModel get detail => _detail!;
  ArticleItemModel? _detail;

  ArticleInfo get articleInfo => detail.articleInfo;

  UserInfoModel get userInfo => detail.authorUserInfo;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    return tryCatchResponse(
      request: ContentAPI.getDetailById(articleId),
      onSuccess: (ResponseModel<ArticleItemModel> res) => safeSetState(
        () => _detail = res.data,
      ),
      reportType: (_) => 'fetch article $articleId detail',
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_detail == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
          child: Container(
            height: 42,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(child: Image.network(userInfo.avatarLarge)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(userInfo.userName),
                        Text(
                          articleInfo.ctime,
                          style: context.textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(detail.userInteract.isFollow ? '已关注' : '未关注'),
                ),
              ],
            ),
          ),
        ),
        if (articleInfo.coverImage.isNotEmpty)
          SliverToBoxAdapter(child: Image.network(articleInfo.coverImage)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(data: articleInfo.markContent),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(context),
    );
  }
}
