// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:juejin/exports.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final NestedWebViewController? controller;

  /// Whether to wrap [WebView] with other common controls.
  final bool isWebViewOnly;

  final bool enableProgressBar;

  static Future<void> open({
    Key? key,
    required String url,
    bool replacement = false,
    bool enableProgressBar = true,
  }) {
    final PageRoute route = defaultPageRoute(
      builder: (BuildContext context) => JJWebView(
        key: key,
        url: url,
        enableProgressBar: enableProgressBar,
      ),
    );
    if (replacement) {
      return navigator.pushReplacement(route);
    }
    return navigator.push(route);
  }

  static const String _tag = '🌐 WebView';

  @override
  State<JJWebView> createState() => _JJWebViewState();
}

class _JJWebViewState extends State<JJWebView> {
  late final ValueNotifier<String> _title = ValueNotifier<String>(
    overlayContext.l10n.webViewTitle,
  );
  late NestedWebViewController _controller =
      widget.controller ?? newWebViewController;
  late Widget _webView = newWebView;

  @override
  void didUpdateWidget(JJWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _controller = newWebViewController;
    }
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? newWebViewController;
    }
    if (widget.url != oldWidget.url ||
        widget.controller != oldWidget.controller ||
        widget.isWebViewOnly != oldWidget.isWebViewOnly ||
        widget.enableProgressBar != oldWidget.enableProgressBar) {
      setState(() => _webView = newWebView);
    }
  }

  NestedWebViewController get newWebViewController {
    return NestedWebViewController(widget.url!);
  }

  Widget get newWebView {
    Widget w = InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          applicationNameForUserAgent: 'Xitu Juejin Flutter',
          mediaPlaybackRequiresUserGesture: false,
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
          transparentBackground: true,
        ),
        android: AndroidInAppWebViewOptions(
          disableDefaultErrorPage: true,
          forceDark: AndroidForceDark.FORCE_DARK_AUTO,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          safeBrowsingEnabled: false,
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
          automaticallyAdjustsScrollIndicatorInsets: true,
          isFraudulentWebsiteWarningEnabled: false,
          sharedCookiesEnabled: true,
        ),
      ),
      initialUrlRequest: URLRequest(
        url: Uri.parse(_controller.initialUrl),
      ),
      onConsoleMessage: (_, ConsoleMessage message) => LogUtil.d(
        'Console message: $message',
        tag: JJWebView._tag,
      ),
      onCreateWindow: (_, __) => Future.value(false),
      onLoadError: _controller.onLoadError,
      onLoadStart: _controller.onLoadStart,
      onLoadStop: _controller.onLoadStop,
      onProgressChanged: _controller.onProgressChanged,
      onTitleChanged: (_, String? s) => _title.value = s ?? _title.value,
      onWebViewCreated: _controller.onWebViewCreated,
      shouldOverrideUrlLoading: _controller.shouldOverrideUrlLoading,
    );
    if (widget.enableProgressBar) {
      w = Stack(
        children: <Widget>[
          w,
          Positioned.fill(
            bottom: null,
            child: ValueListenableBuilder<int>(
              valueListenable: _controller.progressNotifier,
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

class NestedWebViewController {
  NestedWebViewController(this.initialUrl, {this.onLoadComplete});

  final String initialUrl;
  final void Function()? onLoadComplete;

  InAppWebViewController? get controller => _controller;
  InAppWebViewController? _controller;

  final ValueNotifier<double> scrollHeightNotifier = ValueNotifier<double>(1);
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  WebViewStatus _status = WebViewStatus.loading;

  void onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
    _controller?.addJavaScriptHandler(
      handlerName: 'JJHeightNotifier',
      callback: (List<dynamic> arguments) async {
        final int height = int.parse(arguments.first);
        scrollHeightNotifier.value = height.toDouble();
      },
    );
  }

  void onLoadStart(InAppWebViewController controller, Uri? uri) {
    if (uri?.toString() == initialUrl || _status == WebViewStatus.failed) {
      _status = WebViewStatus.loading;
    }
  }

  Future<void> onLoadStop(InAppWebViewController controller, Uri? uri) async {
    if (uri.toString().contains('/appview/post/')) {
      await _controller?.evaluateJavascript(source: removeHeaderJs);
    }
    if (_status != WebViewStatus.failed) {
      await _controller?.evaluateJavascript(source: scrollHeightJs);
      onLoadComplete?.call();
    }
  }

  void onLoadError(
    InAppWebViewController controller,
    Uri? uri,
    int code,
    String message,
  ) {
    LogUtil.e(
      'WebView onLoadError:\n'
      ' - [$uri]\n'
      ' - ($code) $message',
      stackTrace: StackTrace.current,
      tag: JJWebView._tag,
    );
    _status = WebViewStatus.failed;
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    progressNotifier.value = progress;
  }

  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final Uri? uri = navigationAction.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      if (uri.host == Urls.domain) {
        final List<String> path =
            uri.path.split('/').where((String e) => e.isNotEmpty).toList();
        if (path.isNotEmpty) {
          if (path.first == 'post') {
            navigator.pushNamed(
              Routes.articleDetailPage.name,
              arguments: Routes.articleDetailPage.d(path.last),
            );
            return NavigationActionPolicy.CANCEL;
          }
        }
      }
      return NavigationActionPolicy.ALLOW;
    }
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
    return NavigationActionPolicy.CANCEL;
  }
}

enum WebViewStatus { loading, failed, completed }

const String removeHeaderJs = '''
document.querySelectorAll("h1, img.cover-image").forEach((e) => e.remove());
''';

const String scrollHeightJs = '''(function() {
  var height = 0;
  var hasNotifier = window.flutter_inappwebview && window.flutter_inappwebview.callHandler;
  if (!hasNotifier) {
    return;
  }

  function checkAndNotify() {
    var curr = document.body.scrollHeight;
    if (curr !== height) {
      height = curr;
      window.flutter_inappwebview.callHandler(
        'JJHeightNotifier',
        height.toString()
      );
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
