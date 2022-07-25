// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:convert';

import 'package:dio/dio.dart' show DioError, DioErrorType;
import 'package:flutter/foundation.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../utils/log_util.dart';
import 'data_model.dart';
import 'response_model.dart';

class LoadingBase<T extends DataModel> extends LoadingMoreBase<T> {
  LoadingBase({
    required this.request,
    this.onRefresh,
    this.onLoadSucceed,
    this.onLoadFailed,
  });

  Future<ResponseModel<T>> Function(int page, String? lastId) request;
  final VoidCallback? onRefresh;
  final Function(LoadingBase<T> lb, bool isMore)? onLoadSucceed;
  final Function(LoadingBase<T> lb, bool isMore, Object e)? onLoadFailed;

  int total = 0;
  int page = 1;
  String? lastId;
  bool canRequestMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore => canRequestMore;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    canRequestMore = true;
    page = 1;
    lastId = null;
    forceRefresh = !clearBeforeRequest;
    onRefresh?.call();
    final bool result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      final int newPage = isLoadMoreAction ? page + 1 : page;
      final ResponseModel<T> response = await request(newPage, lastId);
      if (response.isSucceed) {
        if (!isLoadMoreAction) {
          clear();
        }
        addAll(response.models!);
        total = response.total!;
        page = response.page ?? newPage;
        lastId = _decodeCursor(response.cursor)?['v'];
        canRequestMore = response.canLoadMore;
        onLoadSucceed?.call(this, isLoadMoreAction);
      } else {
        onLoadFailed?.call(this, isLoadMoreAction, response.msg);
      }
      setState();
      return response.isSucceed;
    } catch (e, s) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        return false;
      }
      LogUtil.e(
        'Error when loading `$T` list in loading base: $e',
        stackTrace: s,
      );
      onLoadFailed?.call(this, isLoadMoreAction, e);
      return false;
    }
  }

  bool get isOnlyFirstPage => page == 1 && !hasMore;

  Map<String, dynamic>? _decodeCursor(String? cursor) {
    if (cursor == null) {
      return null;
    }
    try {
      return jsonDecode(utf8.decode(base64Decode(cursor)));
    } catch (_) {
      return null;
    }
  }
}
