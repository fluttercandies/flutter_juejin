// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';
import '../extensions/num_extension.dart';
import '../extensions/string_extension.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import 'device_util.dart';
import 'log_util.dart';
import 'package_util.dart';

enum FetchType { head, get, post, put, patch, delete }

class HttpUtil {
  const HttpUtil._();

  static const String _tag = '🌐 HttpUtil';
  static bool isLogging = false;

  static late final Dio dio;
  static late final PersistCookieJar cookieJar;
  static late final CookieManager cookieManager;
  static late final BaseOptions baseOptions = BaseOptions(
    connectTimeout: 30000,
    sendTimeout: 30000,
    receiveTimeout: 30000,
    receiveDataWhenStatusError: true,
  );
  static late final List<Interceptor> interceptors = [
    cookieManager,
    _interceptor,
  ];

  static Future<void> init() async {
    final Directory temporaryDir = await getTemporaryDirectory();
    final String cookiesPath = '${temporaryDir.path}/persist_cookies/';
    Directory(cookiesPath).createSync(recursive: true);
    cookieJar = PersistCookieJar(storage: FileStorage(cookiesPath));
    cookieManager = CookieManager(cookieJar);
    dio = Dio()
      ..options = baseOptions
      ..interceptors.addAll(interceptors);
  }

  static ResponseModel<T> _successModel<T extends DataModel>() =>
      ResponseModel<T>.succeed();

  static ResponseModel<T> _failModel<T extends DataModel>(String message) =>
      ResponseModel<T>.failed(
        msg: '${ResponseModel.errorInternalRequest}: $message',
      );

  static ResponseModel<T> _cancelledModel<T extends DataModel>(
    String message,
    String url,
  ) =>
      ResponseModel<T>.cancelled(msg: '$message, $url');

  static Future<T> fetch<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String>? queryParameters,
    Object? body,
    Json? headers,
    String? contentType,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    final Response<T> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      contentType: contentType,
      responseType: responseType,
      cancelToken: cancelToken,
    );
    return response.data!;
  }

  static Future<ResponseModel<T>> fetchModel<T extends DataModel>(
    FetchType fetchType, {
    required String url,
    Map<String, String>? queryParameters,
    Object? body,
    Json? headers,
    String? contentType,
    ResponseType responseType = ResponseType.json,
    CancelToken? cancelToken,
    bool Function(Json json)? modelFilter,
  }) async {
    final Response<Json> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      contentType: contentType,
      responseType: responseType,
      cancelToken: cancelToken,
      modelFilter: modelFilter,
    );

    final Json? resBody = response.data;
    if (resBody?.isNotEmpty ?? false) {
      final ResponseModel<T> model = ResponseModel<T>.fromJson(
        resBody!,
        modelFilter: modelFilter,
      );
      _log('Response model: $model');
      if (!model.isSucceed) {
        _log('Response is not succeed: ${model.msg}');
      }
      return model;
    } else {
      return _handleStatusCode(response);
    }
  }

  static Future<String> getFilenameFromResponse(
    Response<dynamic> res,
    String url,
  ) async {
    String? filename = res.headers
        .value('content-disposition')
        ?.split('; ')
        .where((String element) => element.contains('filename'))
        .first;
    if (filename != null) {
      final RegExp filenameReg = RegExp(r'filename="(.+)"');
      filename = filenameReg.allMatches(filename).first.group(1);
      filename = Uri.decodeComponent(filename!);
    } else {
      filename = url.split('/').last.split('?').first;
    }
    return filename;
  }

  /// Return the saving path if succeed.
  static Future<String> download(
    String url, {
    String? filename,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    Options? options,
    bool deleteIfExist = true,
    bool openAfterDownloaded = false,
  }) async {
    final Completer<String> completer = Completer<String>();
    try {
      final String tempPath = (await getTemporaryDirectory()).path;
      cancelToken ??= CancelToken();
      late final String filename;
      late final String filePath;
      late int totalContentLength;
      String progress = '';
      final Stopwatch stopwatch = Stopwatch()..start();
      await dio.download(
        url,
        (Headers headers) {
          filename = _filenameFromUrl(headers, url);
          filePath = '$tempPath/$filename';
          final File file = File(filePath);
          if (file.existsSync() && deleteIfExist) {
            _log('Deleting existing download file: $filePath');
            file.deleteSync();
          }
          if (file.existsSync()) {
            if (openAfterDownloaded) {
              _log('File exist in $filePath, opening...');
              _openFile(filePath);
            } else {
              _log('File exist in $filePath.');
            }
            completer.complete(filePath);
            cancelToken!.cancel();
            stopwatch.stop();
            return filePath;
          }
          _log(
            'File start download:\n'
            '[URL ]: $url\n'
            '[PATH]: $filePath',
          );
          return filePath;
        },
        data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: (int count, int total) {
          totalContentLength = total;
          final String newProgress;
          if (total == -1) {
            newProgress = count.fileSizeFromBytes;
          } else {
            newProgress = (count / total).toStringAsFixed(2);
          }
          if (newProgress != progress) {
            _log('File download progress: $newProgress ($filename)');
            progress = newProgress;
          }
          progressCallback?.call(count, total);
        },
      );
      stopwatch.stop();
      final StringBuffer sb = StringBuffer(
        'File downloaded:\n'
        '[URL  ]: $url\n'
        '[PATH ]: $filePath',
      );
      if (totalContentLength != -1) {
        final int speed = totalContentLength ~/ stopwatch.elapsed.inSeconds;
        sb.write('\n[SPEED]: ${speed.fileSizeFromBytes}/s');
      }
      _log(sb.toString());
      if (openAfterDownloaded) {
        _openFile(filePath);
      }
      completer.complete(filePath);
    } on DioError catch (e, s) {
      if (e.type != DioErrorType.cancel) {
        completer.completeError(e, s);
      }
    } catch (e, s) {
      _log(
        'File download failed: $e\n'
        '[URL ]: $url\n',
        stackTrace: s,
        isError: true,
      );
      completer.completeError(e, s);
    }
    return completer.future;
  }

  static String _filenameFromUrl(Headers headers, String url) {
    final RegExp filenameReg = RegExp(r'filename\*?=(.*)');
    final List<String>? validHeaders = headers
        .value('content-disposition')
        ?.split(';')
        .where((String e) => filenameReg.hasMatch(e.trim()))
        .map((String e) => e.trim())
        .toList();
    if (validHeaders == null || validHeaders.isEmpty) {
      return url.split('/').last.split('?').first;
    }
    if (validHeaders.any((String h) => h.startsWith('filename*='))) {
      final String header = validHeaders.singleWhere(
        (String h) => h.startsWith('filename*='),
      );
      return Uri.decodeComponent(
        header
            .removeFirst('filename*=')
            .removeFirst('utf-8')
            .removeFirst('UTF-8')
            .removeFirst("''"),
      );
    }
    return Uri.decodeComponent(validHeaders.first.removeAll('filename='));
  }

  static Future<OpenResult?> _openFile(String path) async {
    try {
      _log('Opening file $path...');
      final OpenResult result = await OpenFile.open(path);
      return result;
    } catch (e, s) {
      _log('Error when opening file [$path]: $e', stackTrace: s, isError: true);
      return null;
    }
  }

  static ResponseModel<T> _handleStatusCode<T extends DataModel>(
    Response<dynamic> response,
  ) {
    final int statusCode = response.statusCode ?? 0;
    _log('Response status code: ${response.statusCode}');
    if (statusCode >= 200 && statusCode < 300) {
      _log('Response code success: $statusCode');
      return _successModel();
    } else if (statusCode >= 300 && statusCode < 400) {
      _log('Response code moved: $statusCode');
      return _successModel();
    } else if (statusCode >= 400 && statusCode < 500) {
      final String message = 'Response code client error: $statusCode';
      _log(message);
      return _failModel(message);
    } else if (statusCode >= 500) {
      final String message = 'Response code server error: $statusCode';
      _log(message);
      return _failModel(message);
    } else {
      final String message = 'Response code unknown status: $statusCode';
      _log(message);
      return _failModel(message);
    }
  }

  static Future<Response<T>> getResponse<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String?>? queryParameters,
    Object? body,
    Json? headers,
    String? contentType,
    ResponseType? responseType = ResponseType.json,
    CancelToken? cancelToken,
    bool Function(Json json)? modelFilter,
  }) async {
    if (!url.startsWith(urlRegExp)) {
      url = 'https://$url';
    }
    queryParameters
      ?..putIfAbsent('app_id', () => '$appId')
      ..putIfAbsent('app_name', () => '稀土掘金')
      ..putIfAbsent('channel', () => 'Flutter')
      ..putIfAbsent('device_platform', () => Platform.operatingSystem)
      ..putIfAbsent('device_type', () => DeviceUtil.deviceModel)
      ..putIfAbsent('os_version', () => DeviceUtil.osVersion)
      ..putIfAbsent('version_code', () => '${PackageUtil.versionCode}')
      ..putIfAbsent('version_name', () => PackageUtil.versionName);
    if (body is Map) {
      body.putIfAbsent('client_type', () => appId); // Indicates client type.
    }
    headers ??= <String, String?>{};
    // System headers.
    headers[HttpHeaders.userAgentHeader] = 'Xitu Juejin Flutter APP'
        '(${PackageUtil.versionNameAndCode})';

    // Recreate <String, String> headers and queryParameters.
    final Json effectiveHeaders = headers.map<String, dynamic>(
      (String key, dynamic value) =>
          MapEntry<String, dynamic>(key, value.toString()),
    );
    final Uri replacedUri = Uri.parse(url).replace(
      queryParameters: queryParameters?.map<String, String>(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value.toString()),
      ),
    );
    final Options options = Options(
      followRedirects: true,
      headers: effectiveHeaders,
      receiveDataWhenStatusError: true,
      contentType: contentType,
      responseType: responseType,
    );

    final Response<T> response;
    switch (fetchType) {
      case FetchType.head:
        response = await dio.headUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.get:
        response = await dio.getUri(
          replacedUri,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.post:
        response = await dio.postUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.put:
        response = await dio.putUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.patch:
        response = await dio.patchUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.delete:
        response = await dio.deleteUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
    }
    if (response.data == '') {
      response.data = null;
    }
    return response;
  }

  static void _log(
    Object? message, {
    StackTrace? stackTrace,
    bool isError = false,
  }) {
    if (isLogging) {
      if (isError) {
        LogUtil.e(message, stackTrace: stackTrace, tag: _tag);
      } else {
        LogUtil.d(message, stackTrace: stackTrace, tag: _tag);
      }
    }
  }

  static QueuedInterceptorsWrapper get _interceptor {
    return QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        _log('Fetching(${options.method}) url: ${options.uri}');
        if (options.headers.isNotEmpty) {
          _log('Raw request headers: ${options.headers}');
        }
        if (options.data != null) {
          _log('Raw request body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (Response<dynamic> res, ResponseInterceptorHandler handler) {
        _log(
          'Got response from: ${res.requestOptions.uri} ${res.statusCode}',
        );
        _log('Raw response body: ${res.data}');
        dynamic resolvedData;
        if (res.statusCode == HttpStatus.noContent) {
          resolvedData = _successModel().toJson();
        } else {
          final dynamic data = res.data;
          if (data is String) {
            try {
              // If we do want a JSON all the time, DO try to decode the data.
              resolvedData = jsonDecode(data) as Json?;
            } catch (e) {
              resolvedData = data;
            }
          } else {
            resolvedData = data;
          }
        }
        res.data = resolvedData;
        handler.resolve(res);
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.type == DioErrorType.cancel) {
          e.response ??= Response<Json>(
            requestOptions: e.requestOptions,
            data: _cancelledModel(
              e.message,
              e.requestOptions.uri.toString(),
            ).toJson(),
          );
          handler.resolve(e.response!);
          return;
        }
        if (kDebugMode) {
          _log(e, stackTrace: e.stackTrace, isError: true);
        }
        final bool isConnectionTimeout = e.type == DioErrorType.connectTimeout;
        final bool isStatusError = e.response != null &&
            e.response!.statusCode != null &&
            e.response!.statusCode! >= HttpStatus.internalServerError;
        if (!isConnectionTimeout && isStatusError) {
          _log(
            'Error when requesting ${e.requestOptions.uri}\n$e\n'
            'Raw response data: ${e.response?.data}',
            isError: true,
          );
        }
        if (e.response?.data is String) {
          e.response!.data = _failModel(e.response!.data! as String).toJson();
        }
        e.response ??= Response<Json>(
          requestOptions: e.requestOptions,
          data: _failModel(e.message).toJson(),
        );
        e.response!.data ??= _failModel(e.message).toJson();
        handler.resolve(e.response!);
      },
    );
  }
}
