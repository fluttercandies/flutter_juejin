// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:dio/dio.dart';

import '../constants/constants.dart';
import '../extensions/string_extension.dart';
import '../internals/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/http_util.dart';

class PassportAPI {
  const PassportAPI._();

  static const String _api = '${Urls.apiHost}/passport';
  static const String _user = '$_api/user';

  /// Login failed:
  /// {data: {captcha: , desc_url: , description: 帐号或密码错误, error_code: 1009}, message: error}
  static Future<ResponseModel<UserPassportModel>> login(String u, String p) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_user/login/',
      queryParameters: {
        'aid': '$appId',
        'iid': '2397406981526599', // TODO: 确认构造来源
        'mix_mode': '1',
      },
      body: <String, Object?>{
        'account': u.toEncrypted,
        'password': p.toEncrypted,
      },
      contentType: Headers.formUrlEncodedContentType,
    );
  }

  /// TODO(shirne): refresh token
  static Future<ResponseModel<UserPassportModel>> restore() {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: '$_user/refresh/',
      contentType: Headers.formUrlEncodedContentType,
    );
  }
}
