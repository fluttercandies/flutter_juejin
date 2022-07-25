// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

class RecommendAPI {
  const RecommendAPI._();

  static const String _api = '${Urls.apiHost}/recommend_api/v1';
  static const String _articles = '$_api/article';
  static const String _posts = '$_api/short_msg';

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
}
