// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:juejin/exports.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JJInWebView extends StatefulWidget {
  const JJInWebView({
    Key? key,
    this.url,
    this.controller,
    this.isWebViewOnly = false,
    this.enableProgressBar = true,
  })  : assert(url != null || controller != null),
        super(key: key);

  final String? url;
  final NestedInWebViewController? controller;

  final bool isWebViewOnly;

  final bool enableProgressBar;

  static Future<void> open({
    Key? key,
    required String url,
    bool replacement = false,
    bool enableProgressBar = true,
  }) {
    final PageRoute route = defaultPageRoute(
      builder: (BuildContext context) => JJInWebView(
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

  @override
  State<JJInWebView> createState() => _JJInWebViewState();
}

class _JJInWebViewState extends State<JJInWebView> {
  late final ValueNotifier<String> _title = ValueNotifier<String>(
    overlayContext.l10n.webViewTitle,
  );
  late NestedInWebViewController _webViewController =
      widget.controller ?? newWebViewController;
  late Widget _webView = newWebView;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      builtInZoomControls: true,
      displayZoomControls: false,
      loadWithOverviewMode: true,
      allowFileAccess: true,
      safeBrowsingEnabled: false,
      supportMultipleWindows: false,
    ),
    ios: IOSInAppWebViewOptions(
      allowsAirPlayForMediaPlayback: true,
      allowsBackForwardNavigationGestures: true,
      allowsLinkPreview: true,
      allowsPictureInPictureMediaPlayback: true,
      isFraudulentWebsiteWarningEnabled: false,
    ),
  );

  @override
  void didUpdateWidget(JJInWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _webViewController = newWebViewController;
    }
    if (widget.controller != oldWidget.controller) {
      _webViewController = widget.controller ?? newWebViewController;
    }
    if (widget.url != oldWidget.url ||
        widget.controller != oldWidget.controller ||
        widget.isWebViewOnly != oldWidget.isWebViewOnly ||
        widget.enableProgressBar != oldWidget.enableProgressBar) {
      setState(() => _webView = newWebView);
    }
  }

  NestedInWebViewController get newWebViewController {
    return NestedInWebViewController(
      widget.url!,
      onLoadComplete: () async {
        final String? title = await _webViewController.controller?.getTitle();
        if (title != null) {
          safeSetState(() => _title.value = title);
        }
      },
    );
  }

  Widget get newWebView {
    Widget w = InAppWebView(
      key: webViewKey,
      initialUrlRequest:
          URLRequest(url: Uri.parse(_webViewController.initialUrl)),
      onLoadStart: _webViewController.onPageStarted,
      onLoadStop: _webViewController.onPageFinished,
      onLoadError: _webViewController.onWebResourceError,
      onWebViewCreated: _webViewController.onWebViewCreated,
      onProgressChanged: _webViewController.onProgress,
      onUpdateVisitedHistory: _webViewController.navigationDelegate,
    );
    if (widget.enableProgressBar) {
      w = Stack(
        children: <Widget>[
          w,
          Positioned.fill(
            bottom: null,
            child: ValueListenableBuilder<int>(
              valueListenable: _webViewController.progressNotifier,
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

class NestedInWebViewController {
  NestedInWebViewController(this.initialUrl, {this.onLoadComplete});

  final String initialUrl;
  final void Function()? onLoadComplete;

  InAppWebViewController? get controller => _controller;
  InAppWebViewController? _controller;

  final ValueNotifier<double> scrollHeightNotifier = ValueNotifier<double>(1);
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  WebViewStatus _status = WebViewStatus.loading;

  void onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
  }

  void onPageStarted(InAppWebViewController controller, Uri? url) {
    if (url.toString() == initialUrl || _status == WebViewStatus.failed) {
      _status = WebViewStatus.loading;
    }
  }

  void onPageFinished(InAppWebViewController controller, Uri? url) {
    if (url.toString().contains('/appview/post/')) {
      _controller?.evaluateJavascript(source: removeHeaderJs);
    }
    if (_status != WebViewStatus.failed) {
      _controller?.evaluateJavascript(source: scrollHeightJs);

      _controller?.addJavaScriptHandler(
        handlerName: 'newHeight',
        callback: (List<dynamic> arguments) async {
          int? height = arguments.isNotEmpty
              ? int.tryParse(arguments[0])
              : await controller.getContentHeight();
          scrollHeightNotifier.value = height!.toDouble();
        },
      );

      onLoadComplete?.call();
    }
  }

  void onWebResourceError(controller, url, code, message) {
    LogUtil.e(message, stackTrace: StackTrace.current);
    _status = WebViewStatus.failed;
  }

  void onProgress(controller, progress) {
    progressNotifier.value = progress;
  }

  get navigationDelegate {
    return ((controller, uri, androidIsReload) async {
      final String url = uri.toString();
      if (url == 'about:blank') {
        return NavigationDecision.prevent;
      }
      if (url.startsWith(urlRegExp)) {
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
}

enum WebViewStatus { loading, failed, completed }

const String removeHeaderJs = '''
document.querySelectorAll("h1, img.cover-image").forEach((e) => e.remove());
''';

const String scrollHeightJs = '''(function() {
  var height = 0;

  function checkAndNotify() {
    var curr = document.body.scrollHeight;
    console.log('curr;', curr);
    if (curr !== height) {
      height = curr;
      if (typeof window.flutter_inappwebview !== "undefined" 
          && typeof window.flutter_inappwebview.callHandler !== "undefined"){
            
          window.flutter_inappwebview.callHandler('newHeight',height.toString());
            
      }
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
