import 'dart:convert';
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

  test('PassportAPI', () async {
    // {data: {captcha: , desc_url: , description: 帐号或密码错误，剩余2次机会, error_code: 1033}, message: error}
    // {data: {captcha: , desc_url: , description: 帐号或密码错误, error_code: 1009}, message: error}
    // {data: UserPassportModel, message: success}

    expect(
      () => PassportAPI.login('test@test.com', 'errorpassword'),
      throwsA(const TypeMatcher<ModelMakeError<UserPassportModel>>()),
    );

    final passport = await PassportAPI.login(
      'username',
      'password',
    );

    assert(passport.isSucceed);
  });
}
