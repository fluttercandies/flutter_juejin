// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

enum SortType {
  recommend(200),
  latest(300);

  const SortType(this.value);

  final int value;
}

class RecommendAPI {
  const RecommendAPI._();

  static const String _api = '${Urls.apiHost}/recommend_api/v1';
  static const String _articles = '$_api/article';
  static const String _pins = '$_api/short_msg';

  static Future<ResponseModel<T>> getArticles<T extends DataModel>({
    bool isFollow = false,
    String? lastId,
    String? cateId,
    String? tagId,
    int sortType = 200,
    int limit = 20,
    int idType = 2,
  }) {
    if (isFollow) {
      return getRecommendFollowFeedArticles(
        lastId: lastId,
        idType: idType,
        limit: limit,
      ) as Future<ResponseModel<T>>;
    }
    if (cateId != null) {
      if (tagId != null) {
        return getRecommendCateTagFeedArticles(
          lastId: lastId,
          cateId: cateId,
          tagId: tagId,
          idType: idType,
          limit: limit,
          sortType: sortType,
        ) as Future<ResponseModel<T>>;
      } else {
        return getRecommendCateFeedArticles(
          lastId: lastId,
          cateId: cateId,
          idType: idType,
          limit: limit,
          sortType: sortType,
        ) as Future<ResponseModel<T>>;
      }
    }
    return getAllFeedArticles(lastId: lastId, limit: limit)
        as Future<ResponseModel<T>>;
  }

  static Future<ResponseModel<FeedModel>> getAllFeedArticles({
    String? lastId,
    int limit = 20,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_articles/recommend_all_feed',
      body: <String, dynamic>{
        'cursor': cursorFromLastIdAndLimit(lastId, limit),
        'limit': limit,
        'sort_type': 200,
      },
    );
  }

  static Future<ResponseModel<ArticleItemModel>>
      getRecommendFollowFeedArticles({
    String? lastId,
    int idType = 2,
    int limit = 20,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_articles/recommend_follow_feed',
      body: <String, dynamic>{
        'cursor': lastId,
        'limit': limit,
        'id_type': idType,
      },
    );
  }

  static Future<ResponseModel<ArticleItemModel>> getRecommendCateFeedArticles({
    String? lastId,
    required String cateId,
    int idType = 2,
    int limit = 20,
    int sortType = 200,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_articles/recommend_cate_feed',
      body: <String, dynamic>{
        'cate_id': cateId,
        'cursor': lastId,
        'id_type': idType,
        'limit': limit,
        'sort_type': sortType,
      },
    );
  }

  static Future<ResponseModel<ArticleItemModel>>
      getRecommendCateTagFeedArticles({
    String? lastId,
    required String cateId,
    required String tagId,
    int idType = 2,
    int limit = 20,
    int sortType = 200,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_articles/recommend_cate_tag_feed',
      body: <String, dynamic>{
        'cate_id': cateId,
        'tag_id': tagId,
        'cursor': lastId,
        'id_type': idType,
        'limit': limit,
        'sort_type': sortType,
      },
    );
  }

  static Future<ResponseModel<Tag>> getRecommendTags({
    required String cateId,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_api/tag/recommend_tag_list',
      body: <String, dynamic>{
        'cate_id': cateId,
      },
    );
  }

  static Future<ResponseModel<PinItemModel>> getRecommendPins({
    String? lastId,
    int limit = 20,
    SortType sortType = SortType.latest,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_pins/recommend',
      body: <String, dynamic>{
        'cursor': cursorFromLastIdAndLimit(lastId, limit),
        'limit': limit,
        'sort_type': sortType.value,
      },
    );
  }

  static Future<ResponseModel<PinItemModel>> getRecommendClub(String clubId, {
    String? lastId,
    int limit = 20,
    SortType sortType = SortType.recommend,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_pins/topic',
      body: <String, dynamic>{
        'cursor': cursorFromLastIdAndLimit(lastId, limit),
        'limit': limit,
        'sort_type': sortType.value,
        'topic_id': clubId,
      },
    );
  }
}