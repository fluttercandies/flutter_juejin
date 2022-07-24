// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

class ContentAPI {
  const ContentAPI._();

  static const String _api = '${Urls.apiHost}/content_api/v1';
  static const String _articles = '$_api/article';

  static Future<ResponseModel<ArticleItemModel>> getDetailById(String id) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_articles/detail',
      body: <String, dynamic>{'article_id': id},
    );
  }
}
