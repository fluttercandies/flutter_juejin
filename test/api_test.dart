import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:juejin/exports.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  PackageUtil.initInfoManual(
    PackageInfo(
      appName: 'JJ Test',
      buildNumber: '1',
      packageName: 'com.juejin',
      version: '1',
    ),
  );

  // uncomment this line to test api
  // HttpOverrides.global = null;

  // HttpUtil.isLogging = true;

  HttpUtil.initFromDirectory(Directory.systemTemp);

  test('RecommendAPI', () async {
    final cates = await RecommendAPI.getAllFeedArticles();
    assert(cates.isSucceed);
  });
}
