// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

@FFRoute(name: 'article-detail-page')
class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({Key? key, required this.articleId})
      : super(key: key);

  final String articleId;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ValueNotifier<bool> _authorInTitle = ValueNotifier<bool>(false);

  String get articleId => widget.articleId;

  ArticleItemModel get detail => _detail!;
  ArticleItemModel? _detail;

  ArticleInfo get articleInfo => detail.articleInfo;

  UserInfoModel get userInfo => detail.authorUserInfo;

  late NestedWebviewController _webviewController;
  bool _hasContentLoaded = false;

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
        final String url = '${articleInfo.content}'
            '?mode=${brightness.isDark ? 'dark' : 'light'}';
        LogUtil.d(
          'Loading $url for article $articleId...',
          tag: '📃 Article WebView',
        );
        _webviewController = NestedWebviewController(
          url,
          onLoadComplete: () => safeSetState(() => _hasContentLoaded = true),
        );
      }),
      reportType: (_) => 'fetch article $articleId detail',
    );
  }

  Widget _buildAuthorInTitle(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ValueListenableBuilder<bool>(
        valueListenable: _authorInTitle,
        builder: (_, bool value, __) => AnimatedSlide(
          offset: value ? Offset.zero : const Offset(0, 1.5),
          curve: Curves.easeInOutCubic,
          duration: kThemeAnimationDuration,
          child: Row(
            children: <Widget>[
              userInfo.buildCircleAvatar(),
              const Gap.h(8),
              Expanded(
                child: Text(
                  userInfo.userName,
                  style: context.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: RadiusConstants.r4,
                  color: context.theme.dividerColor.withOpacity(.05),
                ),
                child: Text(
                  '${detail.userInteract.isFollow ? '已' : '未'}关注',
                  style: context.textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorInHeader(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          userInfo.buildCircleAvatar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userInfo.buildNameAndLevel(),
                  Text(
                    '${articleInfo.createTime} · '
                    '阅读 ${articleInfo.viewCount}',
                    style: context.textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Text('${detail.userInteract.isFollow ? '已' : '未'}关注'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
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
          child: VisibilityDetector(
            key: ValueKey<String>('article-$articleId-author'),
            onVisibilityChanged: (VisibilityInfo info) {
              _authorInTitle.value = info.visibleFraction < 0.2;
            },
            child: _buildAuthorInHeader(context),
          ),
        ),
        if (articleInfo.coverImage.isNotEmpty)
          SliverToBoxAdapter(
            child: Image.network(
              articleInfo.slicedCoverImage(
                width: context.mediaQuery.size.width.toPx(),
                extension: 'image',
              ),
              fit: BoxFit.cover,
            ),
          ),
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
            navigationDelegate: _webviewController.navigationDelegate,
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
      appBar: AppBar(
        backgroundColor: context.theme.canvasColor,
        elevation: 0,
        title: _detail != null ? _buildAuthorInTitle(context) : null,
        titleSpacing: 8,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (_detail != null) _buildBody(context),
          if (_detail == null || !_hasContentLoaded)
            Container(
              alignment: Alignment.center,
              color: context.theme.canvasColor,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class NestedWebviewController {
  NestedWebviewController(this.initialUrl, {this.onLoadComplete});

  final String initialUrl;
  final void Function()? onLoadComplete;

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
    _controller?.runJavascript(removeHeaderJs);
    if (_status != WebViewStatus.failed) {
      onLoadComplete?.call();
      _controller?.runJavascript(scrollHeightJs);
    }
  }

  void onWebResourceError(WebResourceError error) {
    LogUtil.e(error, stackTrace: StackTrace.current);
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

  NavigationDelegate get navigationDelegate {
    return ((NavigationRequest request) async {
      Uri requestUri = Uri.parse(request.url);

      if (requestUri.isScheme('HTTP') || requestUri.isScheme('HTTPS')) {
        ///判断是不是内部链接  类似  https://juejin.cn/post/7112770927082864653
        if (requestUri.host == Urls.domain &&
            requestUri.path.startsWith('/post/')) {
          String lastId = requestUri.path.split('/').last;
          navigator.pushNamed(
            Routes.articleDetailPage.name,
            arguments: Routes.articleDetailPage.d(articleId: lastId),
          );
        } else {
          navigator.pushNamed(
            Routes.webviewPage.name,
            arguments: Routes.webviewPage.d(uri: requestUri),
          );
        }
      }

      return NavigationDecision.prevent;
    });
  }
}

enum WebViewStatus { loading, failed, completed }

const String removeHeaderJs = '''
document.querySelectorAll("h1, img.cover-image").forEach((e) => e.remove());
''';

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
