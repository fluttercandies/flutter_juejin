// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

@FFRoute(name: 'article-detail-page')
class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  final ArticleItemModel article;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String get articleId => widget.article.articleId;

  ArticleItemModel get detail => _detail!;
  ArticleItemModel? _detail;

  ArticleInfo get articleInfo => detail.articleInfo;

  UserInfoModel get userInfo => detail.authorUserInfo;

  late NestedWebviewController _webviewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDetail();
    });
  }

  Future<void> _fetchDetail() async {
    final Brightness brightness = overlayContext.brightness;
    return tryCatchResponse(
      request: ContentAPI.getDetailById(articleId),
      onSuccess: (ResponseModel<ArticleItemModel> res) => safeSetState(() {
        _detail = res.data;
        _webviewController = NestedWebviewController(
          '${articleInfo.content}?mode=${brightness.isDark ? 'dark' : 'light'}',
        );
      }),
      reportType: (_) => 'fetch article $articleId detail',
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_detail == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(top: 16),
            child: Text(
              articleInfo.title,
              style: context.textTheme.headline5,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 42,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(child: Image.network(userInfo.avatarLarge)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(userInfo.userName),
                        Text(
                          articleInfo.ctime,
                          style: context.textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(detail.userInteract.isFollow ? '已关注' : '未关注'),
                ),
              ],
            ),
          ),
        ),
        if (articleInfo.coverImage.isNotEmpty)
          SliverToBoxAdapter(child: Image.network(articleInfo.coverImage)),
        ValueListenableBuilder<double>(
          valueListenable: _webviewController.scrollHeightNotifier,
          builder: (BuildContext context, double scrollHeight, Widget? child) {
            return SliverToNestedScrollBoxAdapter(
              childExtent: scrollHeight,
              onScrollOffsetChanged: (double scrollOffset) {
                double y = scrollOffset;
                if (Platform.isAndroid) {
                  // https://github.com/flutter/flutter/issues/75841
                  y *= ui.window.devicePixelRatio;
                }
                _webviewController.controller?.scrollTo(0, y.ceil());
              },
              child: child,
            );
          },
          child: WebView(
            initialUrl: _webviewController.initialUrl,
            onPageStarted: _webviewController.onPageStarted,
            onPageFinished: _webviewController.onPageFinished,
            onWebResourceError: _webviewController.onWebResourceError,
            onWebViewCreated: _webviewController.onWebViewCreated,
            onProgress: _webviewController.onProgress,
            javascriptChannels: <JavascriptChannel>{
              _webviewController.scrollHeightNotifierJavascriptChannel
            },
            javascriptMode: JavascriptMode.unrestricted,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(context),
    );
  }
}

class NestedWebviewController {
  NestedWebviewController(this.initialUrl);

  final String initialUrl;

  WebViewController? get controller => _controller;
  WebViewController? _controller;

  final ValueNotifier<double> scrollHeightNotifier = ValueNotifier<double>(1);
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  WebViewStatus _status = WebViewStatus.loading;

  void onWebViewCreated(WebViewController controller) {
    _controller = controller;
  }

  void onPageStarted(String url) {
    if (url == initialUrl || _status == WebViewStatus.failed) {
      _status = WebViewStatus.loading;
    }
  }

  void onPageFinished(String url) {
    if (_status != WebViewStatus.failed) {
      _controller?.runJavascript(scrollHeightJs);
    }
  }

  void onWebResourceError(WebResourceError error) {
    _status = WebViewStatus.failed;
  }

  void onProgress(int progress) {
    progressNotifier.value = progress;
  }

  JavascriptChannel get scrollHeightNotifierJavascriptChannel {
    return JavascriptChannel(
      name: 'ScrollHeightNotifier',
      onMessageReceived: (JavascriptMessage message) {
        final String msg = message.message;
        final double? height = double.tryParse(msg);
        if (height != null) {
          scrollHeightNotifier.value = height;
          _status = WebViewStatus.completed;
        }
      },
    );
  }
}

enum WebViewStatus { loading, failed, completed }

const String scrollHeightJs = '''(function() {
  var height = 0;
  var notifier = window.ScrollHeightNotifier || window.webkit.messageHandlers.ScrollHeightNotifier;
  if (!notifier) return;
  function checkAndNotify() {
    var curr = document.body.scrollHeight;
    if (curr !== height) {
      height = curr;
      notifier.postMessage(height.toString());
    }
  }
  var timer;
  var ob;
  if (window.ResizeObserver) {
    ob = new ResizeObserver(checkAndNotify);
    ob.observe(document.body);
  } else {
    timer = setTimeout(checkAndNotify, 200);
  }
  window.onbeforeunload = function() {
    ob && ob.disconnect();
    timer && clearTimeout(timer);
  };
})();''';
