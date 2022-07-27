import 'package:juejin/exports.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

@FFRoute(name: 'webview-page')
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.uri}) : super(key: key);

  final Uri uri;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final NestedWebviewController _webviewController =
      NestedWebviewController(
    widget.uri.toString(),
    onLoadComplete: () {
      _webviewController.controller
          ?.getTitle()
          .then((value) => safeSetState(() => _title = value ?? ''));
    },
  );

  var _title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.canvasColor,
        elevation: 0,
        title: Text(
          _title,
          style: context.textTheme.bodyMedium,
        ),
        titleSpacing: 8,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: WebView(
        initialUrl: _webviewController.initialUrl,
        onPageStarted: _webviewController.onPageStarted,
        onPageFinished: _webviewController.onPageFinished,
        onWebResourceError: _webviewController.onWebResourceError,
        onWebViewCreated: _webviewController.onWebViewCreated,
        onProgress: _webviewController.onProgress,
        navigationDelegate: _webviewController.navigationDelegate,
        javascriptMode: JavascriptMode.unrestricted,
        backgroundColor: Colors.transparent,
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
    if (_status != WebViewStatus.failed) {
      onLoadComplete?.call();
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
      Uri requestUri = Uri.parse(request.url);
      if (requestUri.isScheme('HTTP') || requestUri.isScheme('HTTPS')) {
        if (requestUri.host == Urls.domain &&
            requestUri.path.startsWith('/post/')) {
          String lastId = requestUri.path.split('/').last;
          navigator.pushNamed(
            Routes.articleDetailPage.name,
            arguments: Routes.articleDetailPage.d(articleId: lastId),
          );
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }
      if (await canLaunchUrl(requestUri)) {
        launchUrl(requestUri);
      }
      return NavigationDecision.prevent;
    });
  }
}

enum WebViewStatus { loading, failed, completed }
