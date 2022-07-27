// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************
// ignore_for_file: prefer_const_literals_to_create_immutables,unused_local_variable,unused_import,unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:juejin/exports.dart';

const List<String> routeNames = <String>[
  'article-detail-page',
  'home-page',
  'splash-page',
  'webview-page',
];

class Routes {
  const Routes._();

  /// 'article-detail-page'
  ///
  /// [name] : 'article-detail-page'
  ///
  /// [constructors] :
  ///
  /// ArticleDetailPage : [Key? key, String(required) articleId]
  static const _ArticleDetailPage articleDetailPage = _ArticleDetailPage();

  /// 'home-page'
  ///
  /// [name] : 'home-page'
  ///
  /// [constructors] :
  ///
  /// HomePage : [Key? key]
  static const _HomePage homePage = _HomePage();

  /// 'splash-page'
  ///
  /// [name] : 'splash-page'
  ///
  /// [constructors] :
  ///
  /// SplashPage : [Key? key]
  static const _SplashPage splashPage = _SplashPage();

  /// 'webview-page'
  ///
  /// [name] : 'webview-page'
  ///
  /// [constructors] :
  ///
  /// WebViewPage : [Key? key, Uri(required) uri]
  static const _WebviewPage webviewPage = _WebviewPage();
}

class _ArticleDetailPage {
  const _ArticleDetailPage();

  String get name => 'article-detail-page';

  Map<String, dynamic> d({
    Key? key,
    required String articleId,
  }) =>
      <String, dynamic>{
        'key': key,
        'articleId': articleId,
      };

  @override
  String toString() => name;
}

class _HomePage {
  const _HomePage();

  String get name => 'home-page';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _SplashPage {
  const _SplashPage();

  String get name => 'splash-page';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _WebviewPage {
  const _WebviewPage();

  String get name => 'webview-page';

  Map<String, dynamic> d({
    Key? key,
    required Uri uri,
  }) =>
      <String, dynamic>{
        'key': key,
        'uri': uri,
      };

  @override
  String toString() => name;
}
