// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';

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
    bool isModels = false,
    bool Function(Json json)? modelFilter,
  }) {
    List<T> makeModels(List<Json> list) {
      if (modelFilter != null) {
        return list.where(modelFilter).map(makeModel<T>).toList();
      }
      return list.map(makeModel<T>).toList();
    }

    return ResponseModel<T>(
      code: json['err_no'] as int? ?? codeSucceed,
      msg: json['err_msg'] as String? ?? errorExternalRequest,
      data: !isModels && json['data'] != null
          ? makeModel<T>(json['data'] as Json)
          : null,
      rawData: json['data'],
      total: json['count'] as int?,
      canLoadMore: json['has_more'] as bool? ?? false,
      models: isModels && json['data'] != null && json['data'] is List
          ? makeModels((json['data'] as List<dynamic>).cast<Json>())
          : null,
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
