// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

class TagAPI {
  const TagAPI._();

  static const String _api = '${Urls.apiHost}/tag_api/v1';

  static Future<ResponseModel<Category>> getCategories() {
    return HttpUtil.fetchModel(
      FetchType.get,
      url: '$_api/query_category_briefs',
    );
  }
}
