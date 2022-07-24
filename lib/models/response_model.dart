// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart' show DioError, DioErrorType;
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart' show ToastPosition;

import '../utils/log_util.dart';
import '../utils/toast_util.dart';
import 'data_model.dart';

@immutable
class ResponseModel<T extends DataModel> {
  const ResponseModel({
    required this.code,
    required this.msg,
    this.rawData,
    this.data,
    this.total,
    this.canLoadMore = false,
    this.models,
  });

  const ResponseModel.succeed({
    this.rawData,
    this.data,
    this.total,
    this.canLoadMore = false,
    this.models,
  })  : code = codeSucceed,
        msg = '';

  const ResponseModel.failed({
    required this.msg,
    this.rawData,
    this.data,
    this.total,
    this.canLoadMore = false,
    this.models,
  }) : code = codeFailed;

  const ResponseModel.cancelled({
    required this.msg,
    this.rawData,
    this.data,
    this.total,
    this.canLoadMore = false,
    this.models,
  }) : code = codeCancelled;

  factory ResponseModel.fromJson(
    Json json, {
    bool Function(Json json)? modelFilter,
  }) {
    List<T> makeModels(List<Json> list) {
      if (modelFilter != null) {
        return list.where(modelFilter).map(makeModel<T>).toList();
      }
      return list.map(makeModel<T>).toList();
    }

    final Object? data = json['data'];
    final bool hasData = data != null;
    final bool isModels = data is List;
    return ResponseModel<T>(
      code: json['err_no'] as int? ?? codeSucceed,
      msg: json['err_msg'] as String? ?? errorExternalRequest,
      data: hasData && !isModels ? makeModel<T>(data as Json) : null,
      rawData: json['data'],
      total: json['count'] as int?,
      canLoadMore: json['has_more'] as bool? ?? false,
      models: hasData && isModels ? makeModels(data.cast<Json>()) : null,
    );
  }

  ResponseModel<Y> replaceTypeData<Y extends DataModel>({
    Y? data,
    List<Y>? models,
    int? total,
  }) {
    return ResponseModel<Y>(
      code: code,
      msg: msg,
      data: data,
      rawData: rawData,
      total: total,
      canLoadMore: canLoadMore,
      models: models,
    );
  }

  static const int codeSucceed = 0;
  static const int codeFailed = 1;
  static const int codeCancelled = -1;
  static const String errorInternalRequest = '_InternalRequestError';
  static const String errorExternalRequest = '_ExternalError';

  final int code;
  final String msg;
  final T? data;

  /// This is the raw data for the model.
  final Object? rawData;

  /// Below fields only works when requesting a list of data.
  final int? total;
  final bool canLoadMore;
  final List<T>? models;

  bool get isSucceed => code == codeSucceed;

  bool get isFailed => code == codeFailed;

  bool get isCancelled => code == codeCancelled;

  ResponseModel<T> copyWith({
    int? code,
    String? msg,
    String? rawData,
    T? data,
    int? total,
    bool? canLoadMore,
    List<T>? models,
  }) {
    return ResponseModel<T>(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
      rawData: rawData ?? this.rawData,
      total: total ?? this.total,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      models: models ?? this.models,
    );
  }

  Json toJson() {
    return <String, dynamic>{
      'code': code,
      'msg': msg,
      if (data != null) 'data': data!.toJson(),
      if (total != null) 'count': total,
      if (canLoadMore) 'has_more': true,
      if (models != null)
        'data': models!.map((T model) => model.toJson()).toList(),
    };
  }

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

/// 统一封装的针对 [ResponseModel] 网络请求的处理方法。
///
/// 在 `await` 该调用后再执行其他命令等同于 `finally`，只有在每一个回调中都正确地 `await`
/// 才能保证方法有效。
///
/// - [request] 请求的实例
/// - [onSuccess] 请求成功后的回调
/// - [onFailed] 请求接口返回了失败的回调
/// - [onError] 请求过程中发生了内部错误的回调
/// - [onCancelled] 请求被取消的回调
/// - [reportType] 上报的内容构造
Future<void> tryCatchResponse<T extends DataModel>({
  required Future<ResponseModel<T>> request,
  required FutureOr<void> Function(ResponseModel<T> res) onSuccess,
  FutureOr<void> Function(ResponseModel<T> res)? onFailed,
  FutureOr<void> Function(Object? e)? onError,
  FutureOr<void> Function()? onCancelled,
  String? Function(Object? r)? reportType,
  bool showToastOnFailed = true,
  bool showToastOnError = true,
  ToastPosition? failedToastPosition,
  ToastPosition? errorToastPosition,
}) async {
  try {
    final ResponseModel<T> res = await request;
    if (res.isSucceed) {
      await onSuccess(res);
      return;
    }
    // 优先处理取消的操作。
    if (res.isCancelled) {
      LogUtil.w('Request has been cancelled: ${res.msg}');
      await onCancelled?.call();
      return;
    }
    // 回落到请求失败。
    final bool shouldReport = reportType != null && reportType(res) != null;
    if (shouldReport && !res.msg.contains(ResponseModel.errorInternalRequest)) {
      LogUtil.e('Failed when ${reportType(res)}: ${res.msg}');
    }
    if (showToastOnFailed) {
      if (res.msg.contains(ResponseModel.errorInternalRequest)) {
        showToastWithPosition(
          '网络状况差，请稍后重试...',
          position: failedToastPosition,
        );
      } else {
        showToastWithPosition(res.msg, position: failedToastPosition);
      }
    }
    await onFailed?.call(res);
  } catch (e, s) {
    if (e is DioError) {
      // 处理 401 的操作。
      if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == HttpStatus.unauthorized) {
          showToast('身份已失效，请重新登录');
          LogUtil.w(
            'Token has been expired during the request: '
            '${e.requestOptions.uri}',
          );
          return;
        }
      }
      // 处理取消的操作。
      if (e.type == DioErrorType.cancel) {
        LogUtil.w('Request has been cancelled: ${e.requestOptions.uri}');
        await onCancelled?.call();
        return;
      }
    }
    final bool shouldReport = reportType != null && reportType(null) != null;
    if (shouldReport) {
      LogUtil.e(
        'Error when ${reportType(null)}: $e',
        stackTrace: s,
      );
    }
    if (showToastOnError) {
      showErrorToastWithPosition(
        '请求失败 (-1 $e)',
        position: errorToastPosition,
      );
    }
    await onError?.call(e);
  }
}
