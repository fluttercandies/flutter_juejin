// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:juejin/exports.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JJWebView extends StatefulWidget {
  const JJWebView({
    Key? key,
    this.url,
    this.controller,
    this.isWebViewOnly = false,
    this.enableProgressBar = true,
  })  : assert(url != null || controller != null),
        super(key: key);

  final String? url;
  final NestedWebviewController? controller;

  /// Whether to wrap [WebView] with other common controls.
  final bool isWebViewOnly;

  final bool enableProgressBar;

  static Future<void> open({
    required String url,
    bool replacement = false,
    bool isWebViewOnly = false,
  }) {
    final PageRoute route = defaultPageRoute(
      builder: (BuildContext context) => JJWebView(
        url: url,
        isWebViewOnly: isWebViewOnly,
      ),
    );
    if (replacement) {
      return navigator.pushReplacement(route);
    }
    return navigator.push(route);
  }

  @override
  State<JJWebView> createState() => _JJWebViewState();
}

class _JJWebViewState extends State<JJWebView> {
  final ValueNotifier<String> _title = ValueNotifier<String>('网页链接');
  late NestedWebviewController _webviewController =
      widget.controller ?? newWebViewController;
  late Widget _webView = newWebView;

  @override
  void didUpdateWidget(JJWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _webviewController = newWebViewController;
    }
    if (widget.controller != oldWidget.controller) {
      _webviewController = widget.controller ?? newWebViewController;
    }
    if (widget.url != oldWidget.url ||
        widget.controller != oldWidget.controller ||
        widget.isWebViewOnly != oldWidget.isWebViewOnly ||
        widget.enableProgressBar != oldWidget.enableProgressBar) {
      setState(() => _webView = newWebView);
    }
  }

  NestedWebviewController get newWebViewController {
    return NestedWebviewController(
      widget.url!,
      onLoadComplete: () async {
        final String? title = await _webviewController.controller?.getTitle();
        if (title != null) {
          safeSetState(() => _title.value = title);
        }
      },
    );
  }

  Widget get newWebView {
    Widget w = WebView(
      initialUrl: _webviewController.initialUrl,
      onPageStarted: _webviewController.onPageStarted,
      onPageFinished: _webviewController.onPageFinished,
      onWebResourceError: _webviewController.onWebResourceError,
      onWebViewCreated: _webviewController.onWebViewCreated,
      onProgress: _webviewController.onProgress,
      navigationDelegate: _webviewController.navigationDelegate,
      javascriptMode: JavascriptMode.unrestricted,
      backgroundColor: Colors.transparent,
      javascriptChannels: <JavascriptChannel>{
        _webviewController.scrollHeightNotifierJavascriptChannel,
      },
    );
    if (widget.enableProgressBar) {
      w = Stack(
        children: <Widget>[
          w,
          Positioned.fill(
            bottom: null,
            child: ValueListenableBuilder<int>(
              valueListenable: _webviewController.progressNotifier,
              builder: (_, int progress, __) => FractionallySizedBox(
                widthFactor: progress / 100,
                child: Container(color: themeColorLight, height: 1),
              ),
            ),
          ),
        ],
      );
    }
    return w;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.canvasColor,
      elevation: 0,
      title: ValueListenableBuilder<String>(
        valueListenable: _title,
        builder: (_, String title, __) => Text(
          title,
          style: context.textTheme.bodyMedium,
        ),
      ),
      titleSpacing: 8,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isWebViewOnly) {
      return _webView;
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _webView,
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
    if (url.contains('/appview/post/')) {
      _controller?.runJavascript(removeHeaderJs);
    }
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

  NavigationDelegate get navigationDelegate {
    return ((NavigationRequest request) async {
      final String url = request.url;
      if (url == 'about:blank') {
        return NavigationDecision.prevent;
      }
      if (url.startsWith(urlRegExp)) {
        final Uri uri = Uri.parse(request.url);
        if (uri.host == Urls.domain) {
          final List<String> path =
              uri.path.split('/').where((String e) => e.isNotEmpty).toList();
          if (path.isNotEmpty) {
            if (path.first == 'post') {
              navigator.pushNamed(
                Routes.articleDetailPage.name,
                arguments: Routes.articleDetailPage.d(path.last),
              );
              return NavigationDecision.prevent;
            }
          }
        }
        return NavigationDecision.navigate;
      }
      if (await canLaunchUrlString(url)) {
        launchUrlString(url);
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    });
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
