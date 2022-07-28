// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:package_info_plus/package_info_plus.dart';

import 'log_util.dart';

class PackageUtil {
  const PackageUtil._();

  static late final PackageInfo packageInfo;
  static late final String versionName;
  static late final int versionCode;

  /// x.y.z+a
  static String get versionNameAndCode => '$versionName+$versionCode';

  static Future<void> initInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    if (const bool.hasEnvironment('meAppVersion')) {
      final List<String> version = const String.fromEnvironment(
        'meAppVersion',
      ).split('+');
      versionName = version.first;
      versionCode = int.parse(version.last);
    } else {
      versionName = packageInfo.version;
      versionCode = int.tryParse(packageInfo.buildNumber) ?? 1;
    }
    LogUtil.d(
      'Package info: ${const JsonEncoder.withIndent('  ').convert(
        <String, dynamic>{
          'appName': packageInfo.appName,
          'packageName': packageInfo.packageName,
          'version': versionName,
          'buildNumber': versionCode,
        },
      )}',
      tag: '📦 PackageUtil',
    );
  }
}
