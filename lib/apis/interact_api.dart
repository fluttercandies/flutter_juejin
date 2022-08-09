// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

class InteractAPI {
  const InteractAPI._();

  static const String _api = '${Urls.apiHost}/interact_api/v1';
  static const String _comment = '$_api/comment';

  static Future<ResponseModel<CommentItemModel>> getCommentByTypeAndId({
    required FeedItemType type,
    required String id,
    String? lastId,
    int limit = 20,
  }) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_comment/list',
      body: <String, dynamic>{
        'item_type': type.type,
        'item_id': id,
        'cursor': cursorFromLastIdAndLimit(lastId, limit),
        'limit': limit,
      },
    );
  }
}
